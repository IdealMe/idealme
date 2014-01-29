class ResourcesController < ApplicationController
  before_action :set_goals
  def index
    @active_tab = :all
    @articles = Article.where("goal_id IS NOT NULL").to_a
  end

  def goal
    @active_tab = :all
    @goal = Goal.find(params[:goal_id])
    @articles = Article.where(goal: @goal).to_a
    render :index
  end

  def my_goals
    @active_tab = :my_goals
    goal_ids = @goals.map {|goal| goal.id }
    @articles = Article.where(goal_id: goal_ids).to_a
    render :index
  end

  def show
    @article = Article.find(params[:id])
  end

  def set_goals
    @goals = []
    @goals = current_user.goals if current_user
  end

end
