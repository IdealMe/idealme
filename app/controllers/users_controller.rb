class UsersController < ApplicationController
  before_filter :load_user, except: [:welcome, :welcome_save, :dismiss_welcome_message]
  before_filter :ensure_owner, only: [:ensure_owner]
  before_filter :require_authentication

  WELCOME_MESSAGE = 'Hi! Now what? On this page you can keep track of your goals. Drag your goals into the order you want to tackle them. Any courses you take will be kept here too. And <a href="http://idealme-prod.s3.amazonaws.com/Ideal%20Me%20Worksheet%20PDF%20v01.pdf">here\'s</a> the link to download your free Ebook.'

  def profile

    #@tab = params[:tab] || 'goal'
    if @owner
      @goal_users = GoalUser.goal_for(@user).active.includes(:goal, :checkins).order("position ASC")
      @checkins   = Checkin.for_user(@user)
      @courses    = @user.courses
      flash[:notice] = WELCOME_MESSAGE.html_safe if show_welcome_message?
    else
      @goal_users = GoalUser.goal_for(@user).active.private_goal(false).includes(:goal, :checkins).order("position ASC")
      @checkins   = Checkin.for_user(@user).private_goal(false)
    end

    @goal_users.each_with_index do |goal_user, index|
      goal_user.update_attribute(:position, index + 1)
    end
  end

  def welcome
    flash[:notice] = nil
    @goals = Goal.is_welcome.visible.ordered
    render layout: "chromeless"
  end

  def welcome_save
    goal_ids = params[:goal_ids] || {}
    goal_ids = goal_ids.reject { |key, value| value.to_i == 0 }.keys.map(&:to_i)
    if goal_ids && goal_ids.length > 0
      goals = Goal.where(id: goal_ids)
      goals.each { |goal| current_user.subscribe_goal(goal) }
    end
    redirect_to session[:after_goals_path] || user_path(current_user)
  end

  def dismiss_welcome_message
    current_user.update_attribute :welcome_message_dismissed, true
    head :ok
  end

  protected
  # Set the current profile of the given user in the URL, and determine if the active user is the owner of the user profile
  def load_user
    redirect_to(new_user_session_path) and return unless current_user
    if current_user.username == params[:id]
      @user = current_user
    else
      @user = User.where(username: params[:id]).first
    end

    # The requested user does not exist, redirect back to the user's page
    redirect_to(new_user_session_path) and return unless @user
    # Signals the user is browsing their own profile
    @owner = current_user && (@user.id == current_user.id)

  end

  # Ensure that the owner is browsing the curent profile
  def ensure_owner
    redirect_to(user_path(@user)) and return unless @owner
  end

  def show_welcome_message?
    current_user.created_at > 1.day.ago && (!current_user.welcome_message_dismissed)
  end
end
