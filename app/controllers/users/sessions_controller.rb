class Users::SessionsController < Devise::SessionsController
  skip_authorization_check

  def destroy
    super
    flash[:notice] = nil
  end
end
