# Responsible for CanCan abilities
# :read, :create, :update, :destroy
class Ability
  include CanCan::Ability
  # Defines the abilities of each user's roles with the flags in the user table
  def initialize(user)
    # Guests can not read anything


    cannot :read, User
    cannot :read, Course
    cannot :read, Section
    cannot :read, Lecture
    cannot :read, GoalUser


    # Logged in user with cascading permissions
    if user
      if user.access_normal
        can :read, Course do |course|
          user.subscribed_course?(course)
        end
        can :read, Section do |section|
          user.subscribed_section?(section)
        end
        can :read, Lecture do |lecture|
          user.subscribed_lecture?(lecture)
        end
        can :manage, GoalUser, :user_id => user.id
        can :read, GoalUser, :private => false

      end
      if user.access_affiliate
      end
      if user.access_instructor
      end
      if user.access_admin
        can :manage, :all
        can :access, :admin
      end
    end
  end
end
