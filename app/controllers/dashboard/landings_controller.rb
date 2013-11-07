class Dashboard::LandingsController < Dashboard::ApplicationController
  def index
    redirect_to(dashboard_affiliates_path) and return if can?(:access, :affiliate_tracking)
    redirect_to(dashboard_courses_path) and return if can?(:access, :course_creation)
  end
end
