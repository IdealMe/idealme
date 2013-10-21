class Users::SessionsController < Devise::SessionsController
  layout 'minimal'

  skip_authorization_check

  def destroy
    super
    flash[:notice] = nil
  end
end
