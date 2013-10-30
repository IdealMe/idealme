class Admin::FeedbacksController < Admin::BaseController
  before_filter :load_feedback, only: [:show, :edit, :update, :destroy]
  before_filter :load_feedbacks, only: :index
  before_filter :build_feedback, only: [:new, :create]

  # GET /admin/feedbacks
  def index
  end

  # GET /admin/feedbacks/1
  def show
  end

  # GET /admin/feedbacks/new
  def new
  end

  # GET /admin/feedbacks/1/edit
  def edit
  end

  # POST /admin/feedbacks
  def create
    @feedback.save!
    redirect_to edit_admin_feedback_path(@feedback), notice: 'Feedback was successfully created.'
  rescue ActiveRecord::RecordInvalid
    render action: :new
  end

  # PUT /admin/feedbacks/1
  def update
    @feedback.update_attributes!(params[:feedback])
    redirect_to edit_admin_feedback_path(@feedback), notice: 'Feedback was successfully updated.'
  rescue ActiveRecord::RecordInvalid
    render action: :edit
  end

  # DELETE /admin/feedbacks/1
  def destroy
    @feedback.destroy
    redirect_to admin_feedbacks_url, notice: 'CFeedback was successfully deleted'
  end

  protected
  def load_feedback
    @feedback = Feedback.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_feedbacks_path, alert: "Feedback not found"
  end

  def load_feedbacks
    @feedbacks = Feedback.all
  end

  def build_feedback
    @feedback = Feedback.new(params[:feedback])
  end

end
