# Responsible for CanCan abilities
# :read, :create, :update, :destroy
class Ability
  include CanCan::Ability
  # Defines the abilities of each user's roles with the flags in the user table
  def initialize(user)
    # Guests can not read anything
    # Logged in user with cascading permissions
    if user
      if user.access_normal
      end
      if user.access_affiliate
      end
      if user.access_course_creation
      end
      if user.access_admin
        can :manage, :all
        can :access, :admin
      end
    end
  end
end
