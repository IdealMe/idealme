class GoalsController < ApplicationController
  before_filter :require_authentication

  # GET /goals  
  def index
    redirect_to user_path(current_user) and return
  end

  # GET /goals/1
  def show
    @goal_user = GoalUser.where(:id => params[:id]).includes(:goal, :checkins).first


    @checkins_this_week = Checkin.from_this_week.for_goal_user(@goal_user).all
    @checkins_7_weeks = Checkin.last_n_week(7).for_goal_user(@goal_user).all
    @checkins_7_weeks_dates = @checkins_7_weeks.collect { |x| x.created_at.strftime('%Y%m%d') }
    @last_checkin = Checkin.for_goal_user(@goal_user).last


    @goal_mates = GoalUser.goal_mate_for(@goal_user.goal).all

    @discovers = Jewel.all


    @tab = params[:tab] || 'activity'
  end
end
