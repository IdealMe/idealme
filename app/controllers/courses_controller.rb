class CoursesController < ApplicationController
  before_filter :build_course, only: [:show]

  # GET /courses
  def index
    redirect_to markets_path and return
  end

  # GET /courses/1
  def show
    @comment = Comment.new(commentable: @course, owner: current_user, redirect_back_to: course_path(@course))
    @review  = @course.reviews.build
  end

  protected

  def build_course
    @course = Course.with_sections_and_lectures.find(params[:id])
    @comments = Comment.for(@course).includes(:owner, replies: :owner)

    authorize!(:read, @course)

  rescue ActiveRecord::RecordNotFound
    redirect_to markets_path, alert: 'Course not found.'
  end

end
