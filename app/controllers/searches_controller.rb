class SearchesController < ApplicationController
  def index
    @search = params[:q]
    # redirect_to user_path(current_user) and return if @search.nil? || @search.empty?

    @users = User.search( firstname_or_lastname_or_username_cont: @searc h).result.limit(10)
    @courses = Course.search( name_cont: @searc h).result.limit(10)
    @goals = Goal.search( name_cont: @searc h).result.limit(10)
    @discovers = Jewel.search( name_cont: @searc h).result.limit(10)

    @user_goals = GoalUser.where(user_id: current_user.id).includes(:goal).all.map(&:goal)
  end
end
