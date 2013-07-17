class Users::RegistrationsController < Devise::RegistrationsController
  skip_authorization_check

  protected
  def after_update_path_for(resource)
    user_path(resource)
  end

  def after_sign_up_path_for(resource)
  end
end
