class Ajax::UsersController < Ajax::BaseController
  before_filter :require_authentication
  before_filter :filter_params
  before_filter :load_user, only: [:update]
  before_filter :ensure_user, only: [:update]

  def set_timezone
  end

  # PUT /admin/users/1
  def update
    @user.update_attributes!(user_params)
    head :ok
  end

  protected
  def filter_params
    allowed = %w(timezone tagline toured)
    params[:user].slice!(*allowed) if params[:user]
  end

  def ensure_user
    set_status_and_error(401, 'Unauthorized') unless @owner
  end

  def load_user
    @user = User.where(username: params[:id]).first
    @owner = (current_user.try(:id) == @user.id)
  end

  def user_params
    params.require(:user).permit(:timezone)
  end
end
