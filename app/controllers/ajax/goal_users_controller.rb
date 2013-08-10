class Ajax::GoalUsersController < Ajax::BaseController

  def set_privacy
    set_status_and_error('Invalid Parameters', 403) unless params[:goal_user_id]
    
    
    @goal_user = GoalUser.where(:id => params[:goal_user_id]).first
    if @goal_user
      @goal_user.private = !@goal_user.private
      @goal_user.save!
    end
    
  end

end