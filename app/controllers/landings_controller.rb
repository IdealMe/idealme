class LandingsController < ApplicationController
  def index
    redirect_to user_path(current_user) and return if current_user
    @courses = Course.includes(:owner).limit(12)
  end

  def workbook
  end

  def get_the_book
    session[:after_sign_up_path] = user_welcome_path
    session[:after_goals_path]   = resources_path
    @form_post_path = create_workbook_order_orders_path
    if session[:order_params]
      @order = Order.new(session[:order_params])
    else
      @order = Order.create_workbook_order_by_user(order_user)
    end
    @invoice = Order.generate_workbook_invoice(@order)
    render layout: "chromeless"
  end

  def getthebook
    session[:after_sign_up_path] = user_welcome_path
    session[:after_goals_path]   = resources_path
  end

  def getinshape
  end

  def workbook_thanks
  end

  def aweber_callback
    session[:email]              = params[:email]
    SendHipchatMessage.send("New email optin: #{params[:email]}")
    redirect_to '/getthebook'
    #redirect_to new_user_registration_path
  end

  def ping
    render text: :ok, layout: nil
  end

  private
  def order_user
    if current_user
      current_user
    else
      User.new
    end
  end

end
