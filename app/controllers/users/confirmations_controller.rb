class Users::ConfirmationsController < Devise::ConfirmationsController
  # Remove the first skip_before_filter (:require_no_authentication) if you
  # don't want to enable logged users to access the confirmation page.
  skip_before_filter :require_no_authentication
  skip_before_filter :authenticate_user!
  layout 'minimal'
  # PUT /resource/confirmation
  def update
    with_unconfirmed_confirmable do
      if @confirmable.has_no_password?
        @confirmable.attempt_set_password(params[:user])
        if @confirmable.valid?
          do_confirm
        else
          do_show
          @confirmable.errors.clear # so that we wont render :new
        end
      else
        self.class.add_error_on(self, :email, :password_allready_set)
      end
    end

    if !@confirmable.errors.empty?
      render 'users/confirmations/show' # Change this if you don't have the views on default path
    end
  end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    sign_out(:user)
    with_unconfirmed_confirmable do
      if @confirmable.has_no_password?
        do_show
      else
        do_confirm
      end
    end
    if !@confirmable.errors.empty?
      self.resource = @confirmable
      render 'users/confirmations/show' # Change this if you don't have the views on default path
    end
  end

  def after_sign_in_path_for(user)
    user_path(user)
  end

  protected

  def with_unconfirmed_confirmable
    original_token = params[:confirmation_token]
    confirmation_token = Devise.token_generator.digest(User, :confirmation_token, original_token)
    @confirmable = User.find_or_initialize_with_error_by(:confirmation_token, confirmation_token)
    if !@confirmable.new_record?
      @confirmable.only_if_unconfirmed { yield }
    end
  end

  def do_show
    @confirmation_token = params[:confirmation_token]
    @requires_password = true
    self.resource = @confirmable
    render 'users/confirmations/show' # Change this if you don't have the views on default path
  end

  def do_confirm
    @confirmable.confirm!
    set_flash_message :notice, :confirmed

    if current_user
      current_user.confirm!
      redirect_to after_sign_in_path_for(current_user)
    else
      sign_in_and_redirect(resource_name, @confirmable)
    end
  end
end
