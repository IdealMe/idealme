class Admin::UsersController < Admin::BaseController
  before_filter :load_user, :only => [:show, :edit, :update, :destroy]
  before_filter :load_users, :only => :index
  before_filter :build_user, :only => [:new, :create]

  # GET /admin/users
  def index
  end

  # GET /admin/users/1
  def show
  end

  # GET /admin/users/new
  def new
  end

  # GET /admin/users/1/edit
  def edit
  end

  # POST /admin/users
  def create
    @user.skip_confirmation!
    @user.save!
    redirect_to edit_admin_user_path(@user), :notice => 'User was successfully created.'
  rescue ActiveRecord::RecordInvalid
    render :action => :new
  end

  # PUT /admin/users/1
  def update
    @user.update_attributes!(params[:user])
    redirect_to edit_admin_user_path(@user), :notice => 'User was successfully updated.'
  rescue ActiveRecord::RecordInvalid
    render :action => :edit
  end

  # DELETE /admin/users/1
  def destroy
    @user.destroy
    redirect_to admin_users_url, :notice => 'User was successfully deleted'
  end

  protected
  def load_user
    @user = User.where(:username => params[:id]).first
    @instructor = Course.where(owner_id: @user.id).exists?
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_users_path, :alert => "User not found"
  end

  def load_users
    @users = User.all
  end

  def build_user
    @user = User.new(params[:user])
    @user.password = SecureRandom.hex unless @user.password
  end

end
