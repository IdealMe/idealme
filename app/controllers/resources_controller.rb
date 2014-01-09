class ResourcesController < ApplicationController
  def index
    @active_tab = :all
    @articles = Article.where("goal_id IS NOT NULL").all
  end

  def my_goals
    @active_tab = :my_goals
    @articles = Article.where("goal_id IS NOT NULL").all
    render :index
  end

  def show
    @article = Article.find(params[:id])
  end

end
