class Dashboard::LandingsController < Dashboard::ApplicationController
  def index
    redirect_to(dashboard_affiliates_path(tab: :stats)) && return if can?(:access, :affiliate)

    # WHY IS THIS HERE?
    redirect_to(dashboard_courses_path) && return if can?(:access, :course_creation)
  end
end
