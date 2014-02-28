class FeedbacksController < ApplicationController
  before_filter :require_authentication
  before_filter :load_feedback, only: [:show, :edit, :update, :destroy]
  before_filter :load_feedbacks, only: :index
  before_filter :build_feedback, only: [:new, :create]

  # GET /feedbacks
  def index
    redirect_to new_feedback_path and return
  end

  # GET /feedbacks/1
  def show
  end

  # GET /feedbacks/new
  def new
  end

  # GET /feedbacks/1/edit
  def edit
  end

  # POST /feedbacks
  def create
    @feedback.save!
    redirect_to new_feedback_path, notice: 'Feedback was successfully created.'
  rescue ActiveRecord::RecordInvalid

    flash[:alert] = 'Feedback could not be saved. Please ensure you have filled everything out.'
    render action: :new
  end

  # PUT /feedbacks/1
  def update
    @feedback.update_attributes!(params[:feedback])
    redirect_to feedbacks_path, notice: 'Feedback was successfully updated.'
  rescue ActiveRecord::RecordInvalid
    render action: :edit
  end

  # DELETE /feedbacks/1
  def destroy
    @feedback.destroy
    redirect_to feedbacks_url, notice: 'Feedback was successfully deleted'
  end

  protected

  def load_feedback
    @feedback = Feedback.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to feedbacks_path, alert: 'Feedback not found'
  end

  def load_feedbacks
    @feedbacks = current_user.feedbacks
  end

  def build_feedback
    begin
      @feedback = Feedback.new(feedback_params)
    rescue ActionController::ParameterMissing => e
      @feedback = Feedback.new
    end

    @feedback.owner = current_user
    @feedback.feedback_type = Feedback::GENERAL_FEEDBACK unless @feedback.feedback_type
  end

  def feedback_params
    params.require(:feedback).permit!
  end
end
