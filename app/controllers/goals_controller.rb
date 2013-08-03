class GoalsController < ApplicationController
  before_filter :require_authentication

  before_filter :load_goal_user, :only => [:show, :share, :checkin]
  before_filter :ensure_owner

  # GET /goals  
  def index
    redirect_to user_path(current_user) and return
  end

  # GET /goals/1
  def show
    @checkins_this_week = Checkin.from_this_week.for_goal_user(@goal_user).all
    @checkins_7_weeks = Checkin.last_n_week(7).for_goal_user(@goal_user).all
    @checkins_7_weeks_dates = @checkins_7_weeks.collect { |x| x.created_at.strftime('%Y%m%d') }
    @goal_mates = GoalUser.goal_mate_for(@goal_user.goal).all
    @my_gems = Jewel.for_goal(@goal_user.goal).for_user(current_user).all
    @top_gems = (Jewel.for_goal(@goal_user.goal).private_goal(false).all + @my_gems).uniq
    @courses = @goal_user.goal.courses
    @tab = params[:tab] || 'activity'

    @activities = Activity
    if @owner
      supporting_activity_key = current_user.supported_goal_users.includes(:goal).where(:goals => {:id => @goal_user.goal_id}).map(&:to_activity_key)
      if supporting_activity_key && supporting_activity_key.length > 0
        @activities = @activities.where('(sender_id = ? AND sender_type = ?) OR share_key IN (?)', @goal_user.id, @goal_user.class.name, supporting_activity_key)
      else
        @activities = @activities.where('(sender_id = ? AND sender_type = ?)', @goal_user.id, @goal_user.class.name)
      end
    else
      @activities = @activities.where('(sender_id = ? AND sender_type = ?)', @goal_user.id, @goal_user.class.name)
    end

    @activities = @activities.includes(:sender, :trackable, :comments => [:owner, :replies])
    @activities = @activities.order('created_at DESC').all


  end

  # POST /goals/1/share
  def share
    url = params[:url]
    #
    #begin
    #  uri = URI(url)
    #  request = Net::HTTP.new(uri.host)
    #  response = request.request_head(uri.path)
    #  raise URI::InvalidURIError unless response.code.to_i == 200
    #rescue URI::InvalidURIError
    #  redirect_to(goal_path(@goal_user), :alert => 'That was not a valid URL!') and return
    #end
    gem = Jewel.mine(current_user, url)
    @goal_user.add_gem(gem)
    redirect_to goal_path(@goal_user), :notice => 'Successfully shared your gem!'
  end

  # POST /goals/1/checkin
  def checkin
    checkin = @goal_user.checkin(params[:thoughts])
    redirect_to goal_path(@goal_user), :notice => 'Successfully checked in!'
  end

  protected
  def load_goal_user
    @goal_user = GoalUser.where(:id => params[:id]).includes(:goal, :checkins).first
    @owner = current_user && (@goal_user.user_id == current_user.id)
  end

  # Ensure that the owner is browsing the curent profile
  def ensure_owner
    redirect_to(user_path(current_user), :alert => 'That goal does not exist!') and return if (!@owner && @goal_user.private?)
  end
end
