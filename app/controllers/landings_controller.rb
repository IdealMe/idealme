class LandingsController < ApplicationController
  def index
    redirect_to user_path(current_user) and return if current_user
    @courses = Course.includes(:owner).limit(12)
    @vwo = true
  end

  def workbook
    @vwo = true
  end

  def getthebook
    session[:after_sign_up_path] = user_welcome_path
    session[:after_goals_path]   = resources_path
    @vwo = true
  end

  def getinshape
    @vwo = true
  end

  def aweber_callback
    session[:email]              = params[:email]
    redirect_to '/getthebook'
    #redirect_to new_user_registration_path
  end
end
