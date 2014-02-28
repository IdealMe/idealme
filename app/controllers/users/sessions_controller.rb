class Users::SessionsController < Devise::SessionsController
  layout 'minimal'

  skip_authorization_check
  skip_before_filter :require_no_authentication, only: [:create]

  def create
    super
    flash[:notice] = nil
  end

  def destroy
    super
    flash[:notice] = nil
  end

  def new
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    resource.email = session[:email] if session[:email]
    respond_with(resource, serialize_options(resource))
  end

  protected

  def auth_options
    if params[:quick] == '1'
      { scope: resource_name, recall: 'users/registrations#new' }
    else
      { scope: resource_name, recall: 'users/sessions#new' }
    end
  end
end
