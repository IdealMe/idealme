class SearchesController < ApplicationController

  def index
    @search = params[:q]
    #redirect_to user_path(current_user) and return if @search.nil? || @search.empty?

    @users = User.search({:firstname_or_lastname_or_username_cont => @search}).result
    @courses = Course.search({:name_cont => @search}).result
    @goals = Goal.search({:name_cont => @search}).result



    #@projects = Project.search(name_cont: q).result
    #@users = User.search(name_cont: q).result


  end

end
