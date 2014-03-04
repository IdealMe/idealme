class ResourcesController < ApplicationController
  before_action :set_goals
  def index
    @active_tab = :all
    @articles = ArticleGoal.where('article_id is not null').map(&:article).uniq.reject { |article| article.drip_content? }
  end

  def goal
    @active_tab = :all
    @goal = Goal.find(params[:goal_id])
    @articles = ArticleGoal.where(goal: @goal).map(&:article).uniq.compact.reject { |article| article.drip_content? }
    render :index
  end

  def my_goals
    @active_tab = :my_goals
    goal_ids = @goals.map { |goal| goal.id }
    @articles = Article.where(drip_content: false, id: ArticleGoal.where(goal_id: goal_ids).pluck(:article_id).uniq).to_a
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

  def download_workbook
    if current_user
      redirect_to 'http://idealme-prod.s3.amazonaws.com/Design_Your_Ideal_Life_Workbook.pdf', disposition: 'attachment'
    else
      redirect_to "#{root_path}#sign-up"
    end
  end
end
