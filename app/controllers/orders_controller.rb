class OrdersController < ApplicationController
  include LandingsHelper
  # before_filter :require_authentication
  before_filter :init_order, only: [:new, :thanks]
  before_filter :build_order, only: [:create, :create_workbook_order, :create_subscription_order]

  before_filter :ensure_product_user_uniqueness
  before_filter :ensure_user, only: [:create, :create_workbook_order, :create_subscription_order]

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
    render layout: 'minimal'
  end

  def new_workbook
    @form_post_path = create_workbook_order_orders_path
    @order = workbook_order
    @invoice = Order.generate_workbook_invoice(@order)
    render layout: 'minimal'
  end

  def new_action_sidekick
    @form_post_path = create_action_sidekick_order_orders_path
    @order = action_sidekick_order
    @invoice = Order.generate_action_sidekick_invoice(@order)
    render layout: 'minimal'
  end

  def new_subscription
    @form_post_path = create_subscription_order_orders_path
    @order = subscription_order
    @invoice = Order.generate_subscription_invoice(@order)
    render layout: 'minimal'
  end

  def create_workbook_order
    @form_post_path = create_workbook_order_orders_path
    create_order(:new_workbook, WORKBOOK_COST_IN_CENTS, 'Idealme Workbook Postage') do |response|
      sign_in(:user, @user)
      @user.ordered_workbook = true
      @user.save!
      @order.update_attribute(:data, { order_type: "workbook" }.to_json)
      @order.complete!
      session[:conversion_partial] = "landings/ga_workbook_purchased"
      redirect_to(post_order_path)
      AddToAweberList.perform_in(1.minute, @user.id, 'idealme-gotbook')
    end
  end

  def create_action_sidekick_order
    @form_post_path = create_action_sidekick_order_orders_path
    create_order(:new_workbook, ACTION_SIDEKICK_COST_IN_CENTS, 'Idealme Action Sidekick') do |response|
      sign_in(:user, @user)
      @user.ordered_action_sidekick = true
      @user.save!
      @order.update_attribute(:data, { order_type: "action_sidekick" }.to_json)
      @order.complete!
      redirect_to(post_order_path)
      AddToAweberList.perform_in(1.minute, @user.id, 'idealme-sidekick')
    end
  end

  def create_subscription_order
    plan = '1'
    plan = '2' if referer_includes? 'continuity-offer-2'
    @form_post_path = create_subscription_order_orders_path
    create_order(:new_subscription, 0, 'Idealme Insider Circle', false, plan) do |response|
      sign_in(:user, @user)

      Stripe.api_key = ENV['STRIPE_SECRET_KEY']
      customer = Stripe::Customer.retrieve(current_user.stripe_customer_id)
      customer.subscriptions.each do |stripe_subscription|
        subscription = current_user.subscriptions.find_or_initialize_by(stripe_id: stripe_subscription.id)
        subscription.stripe_object = stripe_subscription.to_json
        subscription.save!
        @order.update_attribute(:data, { order_type: "subscription" }.to_json)
        @order.update_attribute(:subscription_id, subscription.id)
      end
      AddToAweberList.perform_in(1.minute, @user.id, 'idealme-subs')

      @order.complete!

      redirect_to(thanks_page_path)
    end
  end

  # POST /orders
  def create
    @form_post_path = orders_path
    create_order(:new, @market.course.cost, @order.course.name) do |response|
      @order.update_attribute(:data, { order_type: "course" }.to_json)
      @user.subscribe_course(@market.course)
      sign_in(:user, @user)
      @order.complete!
    end
  end

  protected

  def post_order_path
    session[:after_order_path] || thanks_page_path
  end

  def create_order(form_controller_action, cost, description, charge = true, plan = nil)
    # create order from posted order form
    @order.cost = cost
    if @order.valid? && @user
      token = params[:stripeToken]
      @user.update_attribute(:stripe_token, token)
      Stripe.api_key = ENV['STRIPE_SECRET_KEY']
      begin
        customer = Stripe::Customer.create(
          card: token,
          description: description,
          plan: plan,
          email: @user.email
        )
        @user.update_attribute(:stripe_customer_id, customer.id)
        if charge
          charge = Stripe::Charge.create(
            amount: cost,
            currency: 'usd',
            customer: customer.id,
            description: description,
          )
          flash[:alert] = nil
          @order.parameters = charge.to_json
        end
        @order.status = Order::STATUS_SUCCESSFUL
        @order.user = @user
        HipchatNotification.perform_async("Order success - #{description} - #{@user.email}")

        @order.save!
        if get_affiliate_user
          AffiliateSale.create_affiliate_sale(@order, get_affiliate_user, get_affiliate_link)
        end
        yield(@response) if block_given?
      rescue Stripe::CardError => e
        # The card has been declined
        HipchatNotification.perform_async("Payment declined - #{e.message} - #{@user.email}")
        flash[:alert] = e.message
        render form_controller_action
      end

    else
      HipchatNotification.perform_async("Order form validation error - \n#{@order.to_yaml}")
      flash[:alert] = 'There was a problem validating your information. Please ensure all your information is correct'
      render form_controller_action
    end
  end

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
        # sign_in(:user, user)
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
      '/orders/new/workbook'
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
    # raise ActiveRecord::RecordInvalid unless @market
  rescue ActiveRecord::RecordInvalid
    redirect_to markets_path and return
  end

  def order_params
    params.require(:order).permit!
  end

  def ensure_product_user_uniqueness
    if current_user && @order && @order.market
      market = Market.where(id: @order.market.id).includes(:course).first
      fail(IdealMeException::RecordNotFound, 'That market does not exist') unless market
      course_user = CourseUser.where(course_id: market.course.id, user_id: current_user.id).first
      redirect_to(course_path(market.course)) and return if course_user
    end
  end

  def build_user
    if @build_user
      @build_user
    else
      @build_user = User.new(
        firstname: @order.card_firstname,
        lastname: @order.card_lastname,
        email: @order.card_email
      )
      @build_user.set_username
      @build_user
    end
  end

  def create_user
    user = build_user
    user.save!
    sign_in(:user, user)
  end

  def referer_includes?(v)
    request.referer.include?(v) if request.referer.present?
  end

  def base_order
    if session[:order_params]
      Order.new(session[:order_params])
    else
      yield
    end
  end

  def action_sidekick_order
    base_order { Order.create_action_sidekick_order_by_user(order_user) }
  end

  def workbook_order
    base_order { Order.create_workbook_order_by_user(order_user) }
  end

  def subscription_order
    base_order { Order.create_subscription_order_by_user(order_user) }
  end

end
