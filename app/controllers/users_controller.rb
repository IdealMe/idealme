class UsersController < ApplicationController
  before_filter :load_user, except: [:welcome, :welcome_save, :dismiss_welcome_message, :sidekick, :drip_content_article]
  before_filter :ensure_owner, only: [:ensure_owner]
  before_filter :require_authentication

  def profile
    @active_tab = params[:tab] || :circle
    @active_tab = @active_tab.to_sym
    @modules      = []
    if @owner
      @goal_users   = GoalUser.goal_for(@user).active.includes(:goal, :checkins).order('position ASC')
      @checkins     = Checkin.for_user(@user)
      @courses      = @user.courses
      drip_articles = @user.drip_articles
      end_date      = 28
      12.times do
        articles = drip_articles.select { |article| article.reveal_after_days <= end_date }
        drip_articles = drip_articles - articles
        if articles.empty?
          break
        else
          end_date = end_date + 28
          @modules.push([
            articles.select { |article| article.reveal_after_days % 28 >= 0 && article.reveal_after_days % 28 <= 7 },
            articles.select { |article| article.reveal_after_days % 28 >= 8 && article.reveal_after_days % 28 <= 14 },
            articles.select { |article| article.reveal_after_days % 28 >= 15 && article.reveal_after_days % 28 <= 21 },
            articles.select { |article| article.reveal_after_days % 28 >= 22 && article.reveal_after_days % 28 <= 28 },
          ])
          articles
        end
      end
    else
      @goal_users = GoalUser.goal_for(@user).active.private_goal(false).includes(:goal, :checkins).order('position ASC')
      @checkins   = Checkin.for_user(@user).private_goal(false)
    end

    @goal_users.each_with_index do |goal_user, index|
      goal_user.update_attribute(:position, index + 1)
    end
  end

  def drip_content_article
    @article = Article.find(params[:slug])
    @comment = Comment.new(commentable: @article, owner: current_user, redirect_back_to: resource_path(@article))
    @comments = Comment.for(@article).includes(:owner, replies: :owner)
    render template: "resources/show"
  end

  def sidekick
    unless current_user.ordered_action_sidekick? || current_user.access_admin?
      redirect_to "/action-sidekick"
    end
  end

  def welcome
    flash[:notice] = nil
    @goals = Goal.is_welcome.visible.ordered
    render layout: 'chromeless'
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

  protected
  # Set the current profile of the given user in the URL, and determine if the active user is the owner of the user profile
  def load_user
    redirect_to(new_user_session_path) && return unless current_user
    if current_user.username == params[:id]
      @user = current_user
    else
      @user = User.where(username: params[:id]).first
    end

    # The requested user does not exist, redirect back to the user's page
    redirect_to(new_user_session_path) && return unless @user
    # Signals the user is browsing their own profile
    @owner = current_user && (@user.id == current_user.id)
  end

  # Ensure that the owner is browsing the curent profile
  def ensure_owner
    redirect_to(user_path(@user)) && return unless @owner
  end

  def show_welcome_message?
    current_user.created_at > 1.day.ago && (!current_user.welcome_message_dismissed)
  end
end
