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

  def toggle_goal
    @goal_user = GoalUser.find_or_initialize_by(user: current_user, goal_id: params[:goal_id])
    if @goal_user.persisted?
      GoalUser.where(user: current_user, goal: @goal_user.goal).destroy_all
      render json: { success: true, status: 'destroyed' }
    else
      @goal_user.save
      render json: { success: true, status: 'created' }
    end
  end
end
