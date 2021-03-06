class LandingsController < ApplicationController
  before_filter :setup_form, only: [:workbook]
  skip_before_filter :verify_authenticity_token

  before_filter :require_authentication, only: [:purchase_continuity_offer]
  include LandingsHelper

  def index
    redirect_to user_path(current_user) and return if current_user
    @courses = Course.includes(:owner, :default_market).limit(12)
    @purchased_workbook = 123
    session[:landing] = landing
    session[:after_order_path] = after_order_path
    render template: 'landings/index', layout: index_layout
  end

  def aweber_callback
    session[:email] = params[:email]
    destination     = session[:landing] || '/getthebook'
    SendHipchatMessage.send("New email optin: #{params[:email]}")
    redirect_to destination
  end

  def workbook
    render layout: 'chromeless'
  end

  def hit_your_goals
    session[:landing] = '/continuity-offer-2'
    render layout: 'chromeless'
  end

  def continuity_offer_1
    setup_order_and_invoice
    @fragment = Fragment.where(slug: 'continuity-offer-1').first
    render layout: 'chromeless'
  end

  def continuity_offer_2
    setup_order_and_invoice
    @confirm_error_class = 'error' if params[:confirm] == 'false'
    @fragment = Fragment.where(slug: 'continuity-offer-2').first
    render layout: 'chromeless'
  end

  def purchase_action_sidekick
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    customer = Stripe::Customer.retrieve(current_user.stripe_customer_id)
    unless current_user.ordered_action_sidekick?
      charge = Stripe::Charge.create(
        :amount => ACTION_SIDEKICK_COST_IN_CENTS,
        :currency => "usd",
        :customer => customer.id, # obtained with Stripe.js
        :description => "Ideal Me Action Sidekick"
      )
      AddToAweberList.perform_in(1.minute, current_user.id, 'idealme-sk')

      current_user.update_attribute :ordered_action_sidekick, true
      @order = Order.create_action_sidekick_order_by_user(current_user)
      @order.status = Order::STATUS_SUCCESSFUL
      @order.update_attribute(:data, { order_type: "action sidekick" }.to_json)
      @order.user = current_user
      @order.complete!
      @conversion = "purchased action sidekick"
      HipchatNotification.perform_async("1 Click Order success - action sidekick - #{current_user.email}")
    end

    respond_to do |format|
      format.json { render json: { success: true, thanks_path: thanks_page_path } }
      format.html { redirect_to thanks_page_path }
    end
  end

  def purchase_continuity_offer
    plan = '1'
    plan = '2' if request.referer.include? 'continuity-offer-2'

    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    customer = Stripe::Customer.retrieve(current_user.stripe_customer_id)
    plans = customer.subscriptions.select { |sub| sub.plan.id.present? }.map { |sub| sub.plan.id }
    unless plans.include?("1") || plans.include?("2")
      sub = customer.subscriptions.create(plan: plan)
      subscription = Subscription.create(
        user: current_user,
        subscribed_days: 0,
        unsubscribed_days: 0,
        total_days: 0,
        stripe_object: sub.to_json,
        stripe_id: sub.id,
      )
      AddToAweberList.perform_in(1.minute, current_user.id, 'idealme-subs')

      @order = Order.create_subscription_order_by_user(current_user)
      @order.status = Order::STATUS_SUCCESSFUL
      @order.subscription_id = subscription.id
      @order.user = current_user
      @order.complete!
      session[:conversion_partial] = "landings/ga_continuity_offer_#{plan}_purchased"
      @conversion = "purchased continuity offer #{plan}"
      HipchatNotification.perform_async("1 Click Order success - subscription plan #{plan} - #{current_user.email}")
    end

    respond_to do |format|
      format.json { render json: { success: true, thanks_path: "/action-sidekick" } }
      format.html { redirect_to "/action-sidekick" }
    end
  end

  def thanks
    thanks_type = params[:thanks_type]
    @fragment = Fragment.where(slug: thanks_type).first
    render layout: 'chromeless'
  end

  def action_sidekick
    setup_sidekick_order_and_invoice
    render layout: 'chromeless'
  end

  def ping
    render text: :ok, layout: nil
  end

  private

  def setup_form
    @form_post_path = create_workbook_order_orders_path
    if session[:order_params]
      @order = Order.new(session[:order_params])
    else
      @order = Order.create_workbook_order_by_user(order_user)
    end
    @order.card_email = session[:email] unless @order.card_email.present?
    @invoice = Order.generate_workbook_invoice(@order)
  end

  def setup_order_and_invoice
    unless current_user && current_user.striped?
      @form_post_path = create_subscription_order_orders_path
      if session[:order_params]
        @order = Order.new(session[:order_params])
      else
        @order = Order.create_subscription_order_by_user(order_user)
      end
      @invoice = Order.generate_subscription_invoice(@order)
    end
  end

  def setup_sidekick_order_and_invoice
    unless current_user && current_user.striped?
      @form_post_path = create_action_sidekick_order_orders_path
      if session[:order_params]
        @order = Order.new(session[:order_params])
      else
        @order = Order.create_action_sidekick_order_by_user(order_user)
      end
      @invoice = Order.generate_action_sidekick_invoice(@order)
    end
  end

  def order_user
    if current_user
      current_user
    else
      User.new
    end
  end

  def index_layout
    if request.path =~ /ideal-life/
      "chromeless"
    else
      "application"
    end
  end

  def landing
    if params[:p] == 'a'
      '/continuity-offer-2'
    elsif params[:p] == 'b'
      '/workbook'
    else
      '/workbook'
    end
  end

  def after_order_path
    if params[:p] == 'a'
      '/continuity-offer-2'
    elsif params[:p] == 'b'
      '/continuity-offer-2'
    else
      '/continuity-offer-1'
    end
  end

end
