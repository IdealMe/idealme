class Dashboard::LandingsController < Dashboard::ApplicationController
  def index
    redirect_to(dashboard_affiliates_path(tab: :stats)) and return if can?(:access, :affiliate)

    # WHY IS THIS HERE?
    redirect_to(dashboard_courses_path) and return if can?(:access, :course_creation)
  end
end
