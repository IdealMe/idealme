class LandingsController < ApplicationController
  def index
    redirect_to user_path(current_user) and return if current_user
    @courses = Course.includes(:owner).limit(12)
  end
end
