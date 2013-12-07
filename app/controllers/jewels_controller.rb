class JewelsController < ApplicationController
  before_filter :load_goal
  def index
    @jewels = @goal.jewels
  end

  def create
    url = params.require(:url)
    jewel = Jewel.mine(current_user, url, @goal)
    render json: {
      url: jewel.url,
      image: jewel.avatar.url(:original),
      title: jewel.kind_to_s,
    }
  rescue ActionController::ParameterMissing => e
    render json: {error: "Missing url"}, status: 500
  end

  protected

  def load_goal
    @goal = Goal.find params[:goal_id]
  end

end
