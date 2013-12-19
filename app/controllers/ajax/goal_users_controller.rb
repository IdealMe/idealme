class Ajax::GoalUsersController < Ajax::BaseController

  def set_privacy
    set_status_and_error('Invalid Parameters', 403) unless params[:goal_user_id]
    @goal_user = GoalUser.where(id: params[:goal_user_id]).first
    @goal_user.privacy_toggle if @goal_user
  end

  def set_order
    ids = params[:goals].keys.map(&:to_i)
    goal_users = current_user.goal_users.where(id: ids)
    goal_users.each do |goal_user|
      position = params[:goals][goal_user.id.to_s]
      goal_user.update_attribute(:position, position.to_i)
    end
    head :ok
  end

  def add_goal
    @goal_user = GoalUser.find_or_create_by(user: current_user, goal_id: params[:goal_id])
    render json: { success: true }
  end

  def remove_goal
    @goal_user = GoalUser.where(user: current_user, goal_id: params[:goal_id]).first
    @goal_user.destroy if @goal_user
    render json: { success: true }
  end

end
