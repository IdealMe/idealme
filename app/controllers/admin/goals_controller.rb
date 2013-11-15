class Admin::GoalsController < Admin::BaseController
  before_filter :load_goal, only: [:show, :edit, :update, :destroy]
  before_filter :load_goals, only: :index
  before_filter :build_goal, only: [:new, :create]

  # GET /admin/goals
  def index
  end

  # GET /admin/goals/1
  def show
  end

  # GET /admin/goals/new
  def new
  end

  # GET /admin/goals/1/edit
  def edit
  end

  # POST /admin/goals
  def create
    @goal.save!
    redirect_to edit_admin_goal_path(@goal), notice: 'Goal was successfully created.'
  rescue ActiveRecord::RecordInvalid
    render action: :new
  end

  # PUT /admin/goals/1
  def update
    @goal.update_attributes!(goal_params)
    redirect_to edit_admin_goal_path(@goal), notice: 'Goal was successfully updated.'
  rescue ActiveRecord::RecordInvalid
    render action: :edit
  end

  # DELETE /admin/goals/1
  def destroy
    @goal.destroy
    redirect_to admin_goals_url, notice: 'CGoal was successfully deleted'
  end

  protected
  def load_goal
    @goal = Goal.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_goals_path, alert: "Goal not found"
  end

  def load_goals
    @goals = Goal.all
  end

  def build_goal
    @goal = Goal.new(goal_params)
  end

  def goal_params
    params.fetch(:goal, {}).permit!
  end

end
