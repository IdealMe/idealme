class UsersController < ApplicationController
  before_filter :set_profile
  before_filter :ensure_owner, :only => [:ensure_owner]
  before_filter :require_authentication

  def profile
    @goal_users = GoalUser.where(:user_id => @user.id).includes(:goal, :checkins).all
  end

  def welcome
    @goals = Goal.is_welcome.visible.ordered
  end

  protected
  # Set the current profile of the given user in the URL, and determine if the active user is the owner of the user profile
  def set_profile
    @owner = false
    @user = User.where(:username => params[:id]).first
    # The requested user does not exist, redirect back to the user's page
    redirect_to(new_user_session_path) and return unless @user
    # Signals the user is browsing their own profile
    @owner = (@user.id == current_user.id) if current_user
  end

  # Ensure that the owner is browsing the curent profile
  def ensure_owner
    redirect_to(user_path(@user)) and return unless @owner
  end
end
