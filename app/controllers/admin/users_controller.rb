class Admin::UsersController < ApplicationController
  # GET /admin/users
  def index
    @users = User.all
  end

  # GET /admin/users/1
  def show
    @user = User.find(params[:id])
  end

  # GET /admin/users/new
  def new
    @user = User.new
  end

  # GET /admin/users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /admin/users
  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to admin_user_path(@user), notice: 'User was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /admin/users/1
  def update
    @user = User.find(params[:id])
    # required for settings form to submit when password is left blank
    if params[:user][:password].blank?
      params[:user].delete('password')
      params[:user].delete('password_confirmation')
    end
    if @user.update_attributes(params[:user])
      redirect_to admin_user_path(@user), notice: 'User was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /admin/users/1
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_url
  end

end
