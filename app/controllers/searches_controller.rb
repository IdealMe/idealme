class SearchesController < ApplicationController

  def index
    @search = params[:q]
    #redirect_to user_path(current_user) and return if @search.nil? || @search.empty?

    @users = User.search({firstname_or_lastname_or_username_cont: @search}).result.limit(10)
    @courses = Course.search({name_cont: @search}).result.limit(10)
    @goals = Goal.search({name_cont: @search}).result.limit(10)
    @discovers = Jewel.search({name_cont: @search}).result.limit(10)



    #@projects = Project.search(name_cont: q).result
    #@users = User.search(name_cont: q).result


  end

end
