class JewelsController < ApplicationController
  before_filter :load_goal
  def index
    @jewels = @goal.jewels.where(visible: true)
  end

  def create
    url = params.require(:url)
    jewel = Jewel.mine(current_user, url, @goal)
    render json: {
      url: jewel.url,
      truncated_url: jewel.url.truncate(50),
      image: jewel.avatar.url(:bigger),
      title: jewel.name,
      truncated_title: jewel.name.truncate(50),
      edit_path: goal_gem_path(@goal, jewel)
    }
  rescue ActionController::ParameterMissing => e
    render json: {error: "Missing url"}, status: 500
  end

  protected

  def load_goal
    @goal = Goal.find params[:goal_id]
  end

end
