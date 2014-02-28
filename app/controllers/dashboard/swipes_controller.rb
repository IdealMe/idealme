class Dashboard::SwipesController < Dashboard::ApplicationController
  before_filter :authenticate

  def index
    @swipes = Course.all
  end

  def show
    @course = Course.where(slug: params[:id]).first
  end

  private
  def check_authentication
    authorize!(:access, :affiliate_tracking)
  end
end
