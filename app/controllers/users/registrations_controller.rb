class Users::RegistrationsController < Devise::RegistrationsController
  skip_authorization_check
  layout 'minimal'

  def create
    super
  end

  def update
    account_update_params = devise_parameter_sanitizer.sanitize(:account_update)

    # required for settings form to submit when password is left blank
    if account_update_params[:password].blank?
      account_update_params.delete("password")
      account_update_params.delete("password_confirmation")
    end

    @user = User.find(current_user.id)
    if @user.update_attributes(account_update_params)
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to after_update_path_for(@user)
    else
      render "edit"
    end
  end

  def new
    flash[:alert] = nil if params[:quick] == '1'
    super
  end

  protected

  def after_update_path_for(resource)
    user_path(resource)
  end

  def after_sign_up_path_for(resource)
    user_welcome_path(resource)
  end

  def auth_options
    { scope: resource_name, recall: "#{controller_path}#new" }
  end
end

