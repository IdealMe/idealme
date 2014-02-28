class Dashboard::ApplicationController < ::ApplicationController
  before_filter :authenticate
  before_filter :set_common_date

  def authenticate
    return if can?(:access, :affiliate_link) || can?(:access, :course_creation)
    fail CanCan::AccessDenied
  end
end
