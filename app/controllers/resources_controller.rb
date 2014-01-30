class ResourcesController < ApplicationController
  before_action :set_goals
  def index
    @active_tab = :all
    @articles = ArticleGoal.where("article_id is not null").map(&:article)
  end

  def goal
    @active_tab = :all
    @goal = Goal.find(params[:goal_id])
    @articles = ArticleGoal.where(goal: @goal).map(&:article).compact
    render :index
  end

  def my_goals
    @active_tab = :my_goals
    goal_ids = @goals.map {|goal| goal.id }
    @articles = Article.where(id: ArticleGoal.where(goal_id: goal_ids).pluck(:article_id).uniq)
    render :index
  end

  def show
    @article = Article.find(params[:id])
    @comment = Comment.new(commentable: @article, owner: current_user, redirect_back_to: resource_path(@article))
    @comments = Comment.for(@article).includes(:owner, replies: :owner)
  end

  def set_goals
    @goals = []
    @goals = current_user.goals if current_user
  end

end
