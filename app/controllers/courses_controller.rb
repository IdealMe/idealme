class CoursesController < ApplicationController
  # GET /courses
  def index
    redirect_to market_path and return
  end

  # GET /courses/1
  def show
    @course = Course.find(params[:id])
  end
end
