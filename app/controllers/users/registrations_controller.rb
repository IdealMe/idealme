class Users::RegistrationsController < Devise::RegistrationsController
  skip_authorization_check
  layout 'minimal'

  def create
    set_username_param
    super
  end

  def new
    flash[:alert] = nil if params[:quick] == '1'
    super
  end

  protected

  def set_username_param
    if params[:user][:username].nil? && params[:user][:email].present?
      params[:user][:username] = params[:user][:email].split('@').first.parameterize('-')
    end
  end

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

