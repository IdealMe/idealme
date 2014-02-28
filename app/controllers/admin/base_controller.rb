# Application controller specific to the admin panel
class Admin::BaseController < ::ApplicationController
  before_filter :authenticate

  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.debug("CanCan: Access denied on #{exception.action} #{exception.subject.inspect}")
    if can? :access, :admin_engine
      redirect_to root_path, alert: exception.message
    else
      redirect_to new_user_session_path, alert: exception.message
    end
  end

  protected
  # Authenticate the current user request and ensure the user is logged in
  def authenticate
    authorize!(:access, :admin)
  end
end
