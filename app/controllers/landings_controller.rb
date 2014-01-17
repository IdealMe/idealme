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
    @vwo = true
  end

  def getinshape
    @vwo = true
  end

  def aweber_callback
    binding.pry
  end
end
