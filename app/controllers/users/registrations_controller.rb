class Users::RegistrationsController < Devise::RegistrationsController
  skip_authorization_check

  def create
    build_resource
    if resource.save
      if session[:invite_registration_active_goal]
        active_goal = ActiveGoal.where(:id => session[:invite_registration_active_goal]).first
        if active_goal
          user = resource
          user.follow!(active_goal.owner) unless user.following?(active_goal.owner)
          active_goal.owner.follow!(user) unless active_goal.owner.following?(user)
          user.support_object!(active_goal) unless user.supporting_object?(active_goal)
        end
        session[:invite_registration_active_goal] = nil
      end

      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  def update
    @user = User.where(:id => current_user.id).first
    unless current_user.has_password
      successfully_updated = @user.update_attributes(params[:user])
      if successfully_updated
        current_user.assign_attributes({:has_password => true}, :as => :internal)
        current_user.save!
      end
    end

    if needs_password?(@user, params)
      successfully_updated = @user.update_with_password(params[:user])
    else
      # remove the virtual current_password attribute update_without_password
      # doesn't know how to ignore it
      params[:user].delete(:current_password)

      successfully_updated = @user.update_without_password(params[:user])
    end

    if successfully_updated
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to after_update_path_for(@user)
    else
      render :edit
    end
  end

  protected
  def after_update_path_for(resource)
    user_path(resource)
  end

  def after_sign_up_path_for(resource)
  end

  private

  # check if we need password to update user data
  # ie if password or email was changed
  # extend this as needed
  def needs_password?(user, params)
    (user.email != params[:user][:email]) || (!params[:user][:password].empty?)
  end
end
