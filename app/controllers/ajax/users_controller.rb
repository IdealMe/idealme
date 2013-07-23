class Ajax::UsersController < ApplicationController
  # GET /ajax/users
  # GET /ajax/users.json
  def index
    @ajax_users = Ajax::User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @ajax_users }
    end
  end

  # GET /ajax/users/1
  # GET /ajax/users/1.json
  def show
    @ajax_user = Ajax::User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ajax_user }
    end
  end

  # GET /ajax/users/new
  # GET /ajax/users/new.json
  def new
    @ajax_user = Ajax::User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ajax_user }
    end
  end

  # GET /ajax/users/1/edit
  def edit
    @ajax_user = Ajax::User.find(params[:id])
  end

  # POST /ajax/users
  # POST /ajax/users.json
  def create
    @ajax_user = Ajax::User.new(params[:ajax_user])

    respond_to do |format|
      if @ajax_user.save
        format.html { redirect_to @ajax_user, notice: 'User was successfully created.' }
        format.json { render json: @ajax_user, status: :created, location: @ajax_user }
      else
        format.html { render action: "new" }
        format.json { render json: @ajax_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /ajax/users/1
  # PUT /ajax/users/1.json
  def update
    @ajax_user = Ajax::User.find(params[:id])

    respond_to do |format|
      if @ajax_user.update_attributes(params[:ajax_user])
        format.html { redirect_to @ajax_user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @ajax_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ajax/users/1
  # DELETE /ajax/users/1.json
  def destroy
    @ajax_user = Ajax::User.find(params[:id])
    @ajax_user.destroy

    respond_to do |format|
      format.html { redirect_to ajax_users_url }
      format.json { head :no_content }
    end
  end
end
