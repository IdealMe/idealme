class OrdersController < ApplicationController
  #before_filter :require_authentication
  before_filter :init_order, only: [:new, :thanks, :paypal_checkout, :paypal_cancel, :paypal_return]
  before_filter :build_order, only: [:create, :create_workbook_order]

  before_filter :ensure_product_user_uniqueness
  before_filter :ensure_user, only: [:create, :create_workbook_order]


  protect_from_forgery except: :thanks


  def thanks
    render :create
  end

  # GET /orders
  def index
    redirect_to markets_path and return
  end

  # GET /orders/new
  def new
    @form_post_path = orders_path
    render layout: "minimal"
  end

  def new_workbook
    @form_post_path = create_workbook_order_orders_path
    if session[:order_params]
      @order = Order.new(session[:order_params])
    else
      @order = Order.create_workbook_order_by_user(order_user)
    end
    @invoice = Order.generate_workbook_invoice(@order)
    render layout: "minimal"
  end

  # create a paypal payment and send the user to the approval url
  def paypal_checkout
    paypal = PayPal.new(paypal_endpoint, paypal_credentials)

    paypal.create_payment(@order.course.cost_in_dollars, "Ideal Me - #{@market.name}", paypal_return_url, paypal_cancel_url)
    session[:payment_id] = paypal.id
    redirect_to paypal.approval_url
  end

  def paypal_return
    paypal = PayPal.new(paypal_endpoint, paypal_credentials)
    result = paypal.execute_payment(session[:payment_id], params['PayerID'], params['token'])
    @order.parameters = result
    @order.gateway = Order::GATEWAY_PAYPAL
    @order.status = Order::STATUS_SUCCESSFUL
    @order.user = current_user
    @order.complete!

    if get_affiliate_user
      AffiliateSale.create_affiliate_sale(@order, get_affiliate_user, get_affiliate_link)
    end
    current_user.subscribe_course(@market.course)
    flash[:alert] = nil
    render :create
  end

  def paypal_cancel
    redirect_to action: :new and return
  end

  def create_workbook_order
    @form_post_path = create_workbook_order_orders_path
    time = @order.time

    if @order.valid? && @user
      @order.cost = 700
      gateway = STRIPE_GATEWAY
      gateway_options = {}
      @order.gateway = Order::GATEWAY_STRIPE
      gateway_options[:description] = "Idealme Workbook Postage"
      gateway_options[:email] = @order.card_email

      @response = gateway.purchase(@order.cost, @order.cc, gateway_options)

      if @response.success?
        flash[:alert] = nil
        Rails.logger.info gateway.store(@order.cc, gateway_options)
        @order.parameters = @response
        @order.status = Order::STATUS_SUCCESSFUL
        @order.user = @user
        @order.complete!
        HipchatNotification.perform_async("Workbook ordered - #{@user.email}")
        sign_in(:user, @user)
        redirect_to(workbook_thanks_path)
      else
        HipchatNotification.perform_async("Payment declined - #{@response.message} - #{@user.email}")
        flash[:alert] = @response.message
        render :new_workbook
      end
    else
      HipchatNotification.perform_async("Order form validation error - \n#{@order.to_yaml}")
      flash[:alert] = 'There was a problem validating your information. Please ensure all your information is correct'
      render :new_workbook
    end
  end

  # POST /orders
  def create
    market_id = @order.market.id
    course_id = @order.course.id
    time = @order.time
    redirect_to(markets_path) and return unless @order.valid_checksum?(market_id, course_id, time)

    if @order.valid? && @user
      @order.cost = @market.course.cost
      gateway = STRIPE_GATEWAY
      gateway_options = {}
      @order.gateway = Order::GATEWAY_STRIPE
      gateway_options[:description] = @order.course.name
      gateway_options[:email] = @order.card_email

      @response = gateway.purchase(@market.course.cost, @order.cc, gateway_options)

      if @response.success?
        flash[:alert] = nil
        Rails.logger.info gateway.store(@order.cc, gateway_options)
        @order.parameters = @response
        @order.status = Order::STATUS_SUCCESSFUL
        @order.user = @user
        @order.complete!
        HipchatNotification.perform_async("Course ordered - #{@order.market.name} - #{@user.email}")

        if get_affiliate_user
          AffiliateSale.create_affiliate_sale(@order, get_affiliate_user, get_affiliate_link)
        end
        @user.subscribe_course(@market.course)
        sign_in(:user, @user)
        #flash[:alert] = nil
      else
        HipchatNotification.perform_async("Payment declined - #{@response.message} - #{@user.email}")
        flash[:alert] = @response.message
        render :new
      end
    else
      HipchatNotification.perform_async("Order form validation error - \n#{@order.to_yaml}")
      flash[:alert] = 'There was a problem validating your information. Please ensure all your information is correct'
      render :new
    end
  end

  protected
  def init_order
    @market = Market.find(params[:id])
    @order = Order.create_order_by_market_and_user(@market, order_user)
    @invoice = Order.generate_invoice(@market.course, get_affiliate_user, get_affiliate_link)
  rescue ActiveRecord::RecordInvalid
    redirect_to markets_path and return
  end

  def order_user
    if current_user
      current_user
    else
      User.new
    end
  end

  def ensure_user
    if current_user
      @user = current_user
    else
      user = build_user
      if user.valid?
        user.save!
        @user = user
        #sign_in(:user, user)
      else
        if user.email.present?
          user = User.where(email: user.email).first
          if user.confirmed?
            flash[:alert] = 'Sign in to your idealme.com account before purchasing'
            session[:previous_url] = return_url
            session[:order_params] = order_params
            redirect_to new_user_session_path and return
          else
            # set user to unconfirmed user
            @user = user
          end
        end
      end
    end
  end

  def return_url
    if @order.market
      "/orders/new/#{@order.market.slug}"
    else
      "/orders/new/workbook"
    end
  end

  def build_order
    @order = Order.new(order_params)
    @market = Market.where(id: @order.market.id).first if @order.market
    @invoice = if @market
                 Order.generate_invoice(@market.course, get_affiliate_user, get_affiliate_link)
               else
                 Order.generate_workbook_invoice(@order)
               end
    #raise ActiveRecord::RecordInvalid unless @market
  rescue ActiveRecord::RecordInvalid
    redirect_to markets_path and return
  end

  def order_params
    params.require(:order).permit!
  end


  def load_active_merchant_validator_with_market
    @market = Market.find(params[:id])
    @active_merchant_validator = ActiveMerchantValidator.new({market: @market})
  rescue ActiveRecord::RecordInvalid
    redirect_to markets_path and return
  end

  def build_active_merchant_validator_with_market
    @active_merchant_validator = ActiveMerchantValidator.new(params[:active_merchant_validator])
    @market = Market.where(id: @active_merchant_validator.market_id).first
    raise ActiveRecord::RecordInvalid unless @market
  rescue ActiveRecord::RecordInvalid
    redirect_to markets_path and return
  end

  def ensure_product_user_uniqueness
    if current_user && @order && @order.market
      market = Market.where(id: @order.market.id).includes(:course).first
      raise(IdealMeException::RecordNotFound, 'That market does not exist') unless market
      course_user = CourseUser.where(course_id: market.course.id, user_id: current_user.id).first
      redirect_to(course_path(market.course)) and return if course_user
    end
  end

  def paypal_return_url
    request.url.sub(/paypal$/,'paypal-return')
  end

  def paypal_cancel_url
    request.url.sub(/paypal$/,'paypal-cancel')
  end

  def paypal_endpoint
    if current_user.access_admin? && Rails.env.production?
      ENV['TEST_IDEALME_PAYPAL_ENDPOINT']
    else
      ENV['IDEALME_PAYPAL_ENDPOINT']
    end
  end

  def paypal_credentials
    if current_user.access_admin? && Rails.env.production?
      [
        ENV['TEST_IDEALME_PAYPAL_AUTH_KEY'],
        ENV['TEST_IDEALME_PAYPAL_AUTH_SECRET']
      ]
    else
      [
        ENV['IDEALME_PAYPAL_AUTH_KEY'],
        ENV['IDEALME_PAYPAL_AUTH_SECRET']
      ]
    end

  end

  def build_user
    if @build_user
      @build_user
    else
      @build_user = User.new({
        firstname: @order.card_firstname,
        lastname: @order.card_lastname,
        email: @order.card_email,
      })
      @build_user.set_username
      @build_user
    end
  end

  def create_user
    user = build_user
    user.save!
    sign_in(:user, user)
  end

end

