class Ability
  include CanCan::Ability

  def initialize(user)
    can :access, :admin_engine
  end
end
