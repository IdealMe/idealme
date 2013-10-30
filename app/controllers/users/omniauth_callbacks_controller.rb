#Users::OmniauthCallbacksController
#
#Overloads the default devise omniauth callback controller
#
#Skips device authorization check
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_authorization_check
  # To call specific method based on the omniauth identity provider used
  def passthru
    render file: "#{Rails.root}/public/404.html", status: 404, layout: false
    # Or alternatively,
    # raise ActionController::RoutingError.new('Not Found')
  end

  def process_oauth(provider)
    omniauth = request.env['omniauth.auth']
    results = User.find_or_create_identity(provider, omniauth, current_user)

    if results[:result] == 1 && results[:identity] && results[:user]
      if session[:invite_registration_active_goal]
        active_goal = ActiveGoal.where(id: session[:invite_registration_active_goal]).first
        if active_goal
          user = results[:user]
          user.follow!(active_goal.owner) unless user.following?(active_goal.owner)
          active_goal.owner.follow!(user) unless active_goal.owner.following?(user)
          user.support_object!(active_goal) unless user.supporting_object?(active_goal)
        end
        session[:invite_registration_active_goal] = nil
      end

      if current_user
        redirect_to(user_identity_path(current_user))
      else
        results[:user].confirm! if results[:user].email
        sign_in_and_redirect results[:user], event: :authentication #this will throw if @user is not activated
      end


    else
      session['devise.facebook_data'] = request.env['omniauth.auth']
      redirect_to(new_user_registration_path)
    end
  end

  def yahoo
    process_oauth(:yahoo)
  end

  def google_oauth2
    process_oauth(:google_oauth2)
  end

  def facebook
    process_oauth(:facebook)
  end

  def twitter
    process_oauth(:twitter)
  end
end
