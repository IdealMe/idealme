class Users::SessionsController < Devise::SessionsController
  layout 'minimal'

  skip_authorization_check

  def create
    super
  end

  def destroy
    super
    flash[:notice] = nil
  end

  protected



  def auth_options
    if params[:quick] == '1'
      { scope: resource_name, recall: "users/registrations#new" }
    else
      { scope: resource_name, recall: "users/sessions#new" }
    end
  end
end
