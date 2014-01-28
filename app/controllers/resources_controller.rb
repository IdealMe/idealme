class ResourcesController < ApplicationController
  def index
    @active_tab = :all
    @articles = Article.where("goal_id IS NOT NULL").all
  end

  def goal
    @active_tab = :all
    @goal = Goal.find(params[:goal_id])
    @articles = Article.where(goal: @goal).all
    render :index
  end

  def my_goals
    @active_tab = :my_goals
    @goals = []
    @goals = current_user.goals if current_user
    goal_ids = @goals.map {|goal| goal.id }
    @articles = Article.where(goal_id: goal_ids).all
    render :index
  end

  def show
    @article = Article.find(params[:id])
  end

end
