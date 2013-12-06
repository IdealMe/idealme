class JewelsController < ApplicationController
  before_filter :load_goal
  def index
    @jewels = @goal.jewels
  end
  
  protected

  def load_goal
    @goal = Goal.find params[:goal_id]
  end

end
