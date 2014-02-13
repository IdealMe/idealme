class LandingsController < ApplicationController
  before_filter :setup_form, only: [:get_the_book, :get_the_body, :upsell]

  def index
    redirect_to user_path(current_user) and return if current_user
    @courses = Course.includes(:owner, :default_market).limit(12)
  end

  def workbook
  end

  def get_the_book
    session[:after_sign_up_path] = user_welcome_path
    session[:after_goals_path]   = resources_path
    render layout: "chromeless"
  end

  def getthebook
    session[:after_sign_up_path] = user_welcome_path
    session[:after_goals_path]   = resources_path
  end

  def get_the_body
    session[:landing] = request.path
    if session[:email].present? || current_user
      render layout: "chromeless"
    else
      redirect_to root_path
    end
  end

  def getinshape
  end

  def workbook_thanks
  end

  def aweber_callback
    session[:email]              = params[:email]
    SendHipchatMessage.send("New email optin: #{params[:email]}")
    redirect_to session[:landing] || '/getthebook'
  end

  def ping
    render text: :ok, layout: nil
  end

  def optin
    @courses = []
    session[:landing] = "/upsell"
    session[:after_order_path] = "/continuity-offer-1"
    render template: "landings/index", layout: "chromeless"
  end
  def upsell
    render layout: "chromeless"
  end
  def continuity_offer_1
    render layout: "chromeless"
  end
  def purchase_continuity_offer
    binding.pry
  end
  def continuity_offer_2
    render layout: "chromeless"
  end
  def trial
    render layout: "chromeless"
  end
  def thanks
    render layout: "chromeless"
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

  def order_user
    if current_user
      current_user
    else
      User.new
    end
  end

end
