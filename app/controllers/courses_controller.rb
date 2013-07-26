class CoursesController < ApplicationController
  before_filter :require_authentication, :only => [:show]
  before_filter :build_course, :only => [:show]

  # GET /courses
  def index
    redirect_to markets_path and return
  end

  # GET /courses/1
  def show
    
  end

  protected

  def build_course
    @course = Course.with_sections_and_lectures.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    redirect_to markets_path, :alert => 'Course not found.'
  end

end
