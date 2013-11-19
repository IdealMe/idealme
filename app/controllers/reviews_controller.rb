class ReviewsController < ApplicationController
  before_filter :require_authentication

  before_filter :load_course

  before_filter :load_review, only: [:show, :edit, :update, :destroy]
  before_filter :load_reviews, only: [:index]
  before_filter :build_review, only: [:new, :create]


  # GET /reviews
  def index
  end

  # GET /reviews/1
  def show
    @review = Review.find(params[:id])
  end

  # GET /reviews/new
  def new
  end

  # GET /reviews/1/edit
  def edit
  end

  # POST /reviews
  def create
    @review.save!
    redirect_to course_path(@course), notice: 'Review was successfully created.'
  rescue ActiveRecord::RecordInvalid
    render action: :new
  end

  # PUT /reviews/1
  def update
    @review.update_attributes!(params[:review])
    redirect_to course_path(@course), notice: 'Review was successfully updated.'
  rescue ActiveRecord::RecordInvalid
    render action => :edit
  end

  # DELETE /reviews/1
  def destroy
    @review.destroy
    redirect_to course_path(@course), notice: 'Review was successfully deleted'
  end

  protected

  def load_course
    @course = Course.find(params[:course_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to courses_path, alert: "course not found"
  end

  def load_reviews
    @reviews = @course.reviews
  end

  def build_review
    @review = Review.new(review_params)
    @review.course = @course
    @review.owner = current_user
  end

  def review_params
    params.require(:review).permit!
  end
end
