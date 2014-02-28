class Ajax::CheckinsController < Ajax::BaseController
  # before_filter :require_authentication
  # GET /ajax/checkins.json
  def index
    @checkins = Checkin.all
  end

  # GET /ajax/checkins/1.json
  def show
    @checkin = Checkin.find(params[:id])
  end

  def add_checkin
    goal_user_id = params[:goal_user_id]
    goal_user = GoalUser.where(id: goal_user_id, user_id: current_user.id).first
    @checkin = Checkin.where(goal_user_id: goal_user.id).
        where('created_at >= ? AND created_at <= ?', DateTime.now.beginning_of_day, DateTime.now.end_of_day).first_or_create
  end
end
