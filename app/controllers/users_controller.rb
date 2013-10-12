class UsersController < ApplicationController
  before_filter :load_user
  before_filter :ensure_owner, :only => [:ensure_owner]
  before_filter :require_authentication

  def profile
    redirect_to user_welcome_path if current_user.sign_in_count == 1
    #@tab = params[:tab] || 'goal'
    if @owner
      @goal_users = GoalUser.goal_for(@user).active.includes(:goal, :checkins).all
      @checkins = Checkin.for_user(@user).all
      @courses = @user.courses
      
    else
      @goal_users = GoalUser.goal_for(@user).active.private_goal(false).includes(:goal, :checkins).all
      @checkins = Checkin.for_user(@user).private_goal(false).all
    end
  end

  def welcome
    @goals = Goal.is_welcome.visible.ordered
  end

  def welcome_save
    goal_ids = params[:goal_ids].reject { |key, value| value.to_i == 0 }.keys.map(&:to_i)
    if goal_ids && goal_ids.length > 0
      goals = Goal.where(:id => goal_ids).all
      goals.each { |goal| current_user.subscribe_goal(goal) }
    end
    redirect_to user_path(current_user)
  end

  protected
  # Set the current profile of the given user in the URL, and determine if the active user is the owner of the user profile
  def load_user
    @user = User.where(:username => params[:id]).first
    # The requested user does not exist, redirect back to the user's page
    redirect_to(new_user_session_path) and return unless @user
    # Signals the user is browsing their own profile
    @owner = current_user && (@user.id == current_user.id)
  end

  # Ensure that the owner is browsing the curent profile
  def ensure_owner
    redirect_to(user_path(@user)) and return unless @owner
  end
end
