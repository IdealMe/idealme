module Admin::CoursesHelper

  def course_details_active?
    (params[:active_view] == "details") ? "active" :
      (params[:active_view].present?) ? "" : "active"
  end

  def course_previews_active?
    (params[:active_view] == "previews") ? "active" : ""
  end

  def course_content_active?
    (params[:active_view] == "sections") ? "active" : ""
  end

end
