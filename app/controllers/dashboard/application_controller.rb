class Dashboard::ApplicationController < ::ApplicationController
  before_filter :authenticate

  def authenticate
    return if can?(:access, :affiliate_tracking) || can?(:access, :course_creation)
    raise CanCan::AccessDenied
  end
end