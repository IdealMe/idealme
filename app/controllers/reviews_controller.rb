class ReviewsController < ApplicationController
  before_filter :require_authentication

  before_filter :load_market

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
    redirect_to market_path(@market), notice: 'Review was successfully created.'
  rescue ActiveRecord::RecordInvalid
    render action: :new
  end

  # PUT /reviews/1
  def update
    @review.update_attributes!(params[:review])
    redirect_to market_path(@market), notice: 'Review was successfully updated.'
  rescue ActiveRecord::RecordInvalid
    render action => :edit
  end

  # DELETE /reviews/1
  def destroy
    @review.destroy
    redirect_to market_path(@market), notice: 'Review was successfully deleted'
  end

  protected

  def load_market
    @market = Market.find(params[:market_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to markets_path, alert: "Market not found"
  end

  def load_reviews
    @reviews = @market.course.reviews
  end

  def build_review
    @review = Review.new(params[:review])
    @review.course = @market.course
    @review.owner = current_user
  end
end
