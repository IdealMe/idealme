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
end
