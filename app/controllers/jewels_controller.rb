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
      image: jewel.avatar.url(:bigger),
      title: jewel.name,
    }
  rescue ActionController::ParameterMissing => e
    render json: {error: "Missing url"}, status: 500
  end

  protected

  def load_goal
    @goal = Goal.find params[:goal_id]
  end

end
