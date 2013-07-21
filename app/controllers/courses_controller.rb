class CoursesController < ApplicationController
  before_filter :require_authentication, :only => [:show]

  # GET /courses
  def index
    redirect_to markets_path and return
  end

  # GET /courses/1
  def show
    @course = Course.find(params[:id])
  end
end
