class GoalsController < ApplicationController
  before_filter :require_authentication

  before_filter :load_goals, only: [:index]
  before_filter :load_goal_user, only: [:show, :filter]
  before_filter :load_active_goal_user, only: [:share, :checkin, :archive, :complete]
  before_filter :load_archived_goal_users, only: [:archived]
  before_filter :load_archived_goal_user, only: [:activate]
  #before_filter :ensure_owner, only: [:show, :share, :checkin]

  # GET /goals
  def index
  end

  def choose
    goal_ids = params[:goal_ids].reject { |key, value| value.to_i == 0 }.keys.map(&:to_i)
    if goal_ids && goal_ids.length > 0
      goals = Goal.all
      goals.each do |goal|
        if goal_ids.include? goal.id
          current_user.subscribe_goal(goal)
        else
          current_user.unsubscribe_goal(goal)
        end
      end
    end
    redirect_to user_path(current_user)
  end

  # GET /goals/1
  def show
    #@jewels = @goal.jewels.where(visible: true)
    @jewels = @goal.jewels.filter(:all).order("up_votes DESC")
    @filter_name = "all"
  end

  def filter
    if params[:filter_name] == 'saved'
      @jewels = current_user.jewels.where(visible: true, goal_id: @goal.id)
    else
      @jewels = @goal.jewels.filter(params[:filter_name])
    end
    @jewels.order('up_votes DESC')
    @filter_name = params[:filter_name]
    render :show
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
    #  redirect_to(goal_path(@goal_user), alert: 'That was not a valid URL!') and return
    #end
    gem = Jewel.mine(current_user, url)
    @goal_user.add_gem(gem)
    redirect_to goal_path(@goal_user), notice: 'Successfully shared your gem!'
  end

  # POST /goals/1/checkin
  def checkin
    checkin = @goal_user.checkin(params[:thoughts])
    redirect_to goal_path(@goal_user), notice: 'Successfully checked in!'
  end

  def activate
    @goal_user.active!

    return_path = goal_path(@goal_user)
    return_path = params[:return_path] if params[:return_path]

    redirect_to return_path, notice: 'Successfully activated!'
  end

  def complete
    @goal_user.complete!
    return_path = goal_path(@goal_user)
    return_path = params[:return_path] if params[:return_path]

    redirect_to return_path, notice: 'Successfully completed!'
  end

  def archive
    @goal_user.archive!
    return_path = goal_path(@goal_user)
    return_path = params[:return_path] if params[:return_path]

    redirect_to return_path, notice: 'Successfully archived!'
  end

  def archived

  end

  def toggle
    goal_user = GoalUser.where(user: current_user, goal_id: params[:id]).first
    if goal_user
      goal_user.destroy
      render json: {status: "destroyed"}
    else
      GoalUser.create(user: current_user, goal_id: params[:id])
      render json: {status: "created"}
    end
  end

  protected

  def load_archived_goal_users
    @goal_users = current_user.goal_users.archived.all
  end

  def load_goals
    @goals = Goal.all
    @user_goals = GoalUser.where(user_id: current_user.id).includes(:goal).all.map(&:goal)
  end

  def load_goal_user
    @goal_user = GoalUser.find_or_initialize_by(user: current_user, goal: Goal.find(params[:id]))
    @goal = @goal_user.goal
    @owner = current_user && (@goal_user.user_id == current_user.id)
  end

  def load_active_goal_user
    @goal_user = GoalUser.active.where(id: params[:id]).includes(:goal, :checkins).first
    @owner = current_user && (@goal_user.user_id == current_user.id)
  end

  def load_archived_goal_user
    @goal_user = GoalUser.archived.where(id: params[:id]).includes(:goal, :checkins).first
    @owner = current_user && (@goal_user.user_id == current_user.id)
  end

  # Ensure that the owner is browsing the curent profile
  def ensure_owner
    redirect_to(user_path(current_user), alert: 'That goal does not exist!') and return if (!@owner && @goal_user && @goal_user.private?)
  end
end
