class OrdersController < ApplicationController
  before_filter :require_authentication
  before_filter :init_order, :only => [:new, :thanks, :paypal_checkout, :paypal_cancel, :paypal_return]
  before_filter :build_order, :only => [:create]

  before_filter :ensure_product_user_uniqueness


  protect_from_forgery :except => :thanks


  def thanks
    render :create
  end

  # GET /orders
  def index
    redirect_to markets_path and return
  end

  # GET /orders/new
  def new
  end

  # create a paypal payment and send the user to the approval url
  def paypal_checkout
    paypal = PayPal.new

    paypal.create_payment(@order.course.cost_in_dollars, "Ideal Me - #{@market.name}", paypal_return_url, paypal_cancel_url)
    session[:payment_id] = paypal.id
    redirect_to paypal.approval_url
  end

  def paypal_return
    paypal = PayPal.new
    result = paypal.execute_payment(session[:payment_id], params['PayerID'], params['token'])
    @order.parameters = result
    @order.gateway = Order::GATEWAY_PAYPAL
    @order.status = Order::STATUS_SUCCESSFUL
    @order.save!

    if get_affiliate_user
      AffiliateSale.create_affiliate_sale(@order, get_affiliate_user, get_affiliate_tracking)
    end
    current_user.subscribe_course(@market.course)
    flash[:alert] = nil
    render :create
  end

  def paypal_cancel
    redirect_to action: :new and return
  end

  # POST /orders
  def create
    market_id = @order.market.id
    course_id = @order.course.id
    time = @order.time
    redirect_to(markets_path) and return unless @order.valid_checksum?(market_id, course_id, time)

    if @order.valid?
      @order.cost = @market.course.cost
      #gateway = AUTHORIZED_NET_GATEWAY
      gateway = STRIPE_GATEWAY

      gateway_options = {}
      if gateway.is_a?(ActiveMerchant::Billing::AuthorizeNetGateway)
        @order.gateway = Order::GATEWAY_AUTHORIZE_NET
        #gateway_options[:order_id] = Order.generate_invoice(@course.id)
        gateway_options[:description] = @order.course.name
        gateway_options[:email] = @order.card_email
        gateway_options[:customer] = @order.user.id
      end

      if gateway.is_a?(ActiveMerchant::Billing::StripeGateway)
        @order.gateway = Order::GATEWAY_STRIPE
        gateway_options[:description] = @order.course.name
        gateway_options[:email] = @order.card_email
        #metadata_options = [:description,:browser_ip,:user_agent,:referrer]
      end


      @response = gateway.purchase(@market.course.cost, @order.cc, gateway_options)
      if @response.success?
        if gateway.is_a?(ActiveMerchant::Billing::StripeGateway)
         Rails.logger.info gateway.store(@order.cc, gateway_options)
        end
        @order.parameters = @response
        @order.status = Order::STATUS_SUCCESSFUL
        @order.save!

        if get_affiliate_user
          AffiliateSale.create_affiliate_sale(@order, get_affiliate_user, get_affiliate_tracking)
        end
        current_user.subscribe_course(@market.course)
        flash[:alert] = nil
      else
        flash[:alert] = @response.message
        render :new
      end
    else
      flash[:alert] = 'There was a problem validating your information. Please ensure all your information are correct'
      render :new
    end


  end

  protected
  def init_order
    @market = Market.find(params[:id])
    @order = Order.create_order_by_market_and_user(@market, current_user)
    @invoice = Order.generate_invoice(@market.course, get_affiliate_user, get_affiliate_tracking)
  rescue ActiveRecord::RecordInvalid
    redirect_to markets_path and return
  end


  def build_order
    @order = Order.new(params[:order])
    @market = Market.where(:id => @order.market.id).first
    @invoice = Order.generate_invoice(@market.course, get_affiliate_user, get_affiliate_tracking)
    raise ActiveRecord::RecordInvalid unless @market
  rescue ActiveRecord::RecordInvalid
    redirect_to markets_path and return
  end


  def load_active_merchant_validator_with_market
    @market = Market.find(params[:id])
    @active_merchant_validator = ActiveMerchantValidator.new({:market => @market})
  rescue ActiveRecord::RecordInvalid
    redirect_to markets_path and return
  end

  def build_active_merchant_validator_with_market
    @active_merchant_validator = ActiveMerchantValidator.new(params[:active_merchant_validator])
    @market = Market.where(:id => @active_merchant_validator.market_id).first
    raise ActiveRecord::RecordInvalid unless @market
  rescue ActiveRecord::RecordInvalid
    redirect_to markets_path and return
  end

  def ensure_product_user_uniqueness
    if current_user
      market = Market.where(:id => @order.market.id).includes(:course).first
      raise(IdealMeException::RecordNotFound, 'That market does not exist') unless market
      course_user = CourseUser.where(:course_id => market.course.id, :user_id => current_user.id).first
      redirect_to(course_path(market.course)) and return if course_user
    end
  end

  def paypal_return_url
    request.url.sub(/paypal$/,'paypal-return')
  end

  def paypal_cancel_url
    request.url.sub(/paypal$/,'paypal-cancel')
  end
end

