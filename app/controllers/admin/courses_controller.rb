class Admin::CoursesController < Admin::BaseController
  before_filter :load_course, only: [:show, :edit, :update, :destroy]
  before_filter :load_courses, only: :index
  before_filter :build_course, only: [:new, :create]

  def sort_sections
    course = Course.find(params[:id])
    params[:section].each_with_index do |id, index|
      course.sections.update_all({ position: index + 1 }, { id: id })
    end
    render nothing: true
  end

  # GET /admin/courses
  def index
  end

  # GET /admin/courses/1
  def show
  end

  # GET /admin/courses/new
  def new
  end

  # GET /admin/courses/1/edit
  def edit
  end

  # POST /admin/courses
  def create
    @course.save!
    redirect_to edit_admin_course_path(@course), notice: 'Course was successfully created.'
  rescue ActiveRecord::RecordInvalid
    render action: :new
  end

  # PUT /admin/courses/1
  def update
    @course.update_attributes!(course_params)
    # redirect_to edit_admin_course_path(@course), notice: 'Course was successfully updated.'
    flash[:notice] = 'Course was successfully updated.'
    render action: :edit
  rescue ActiveRecord::RecordInvalid
    render action: :edit
  end

  # DELETE /admin/courses/1
  def destroy
    @course.destroy
    redirect_to admin_courses_url, notice: 'Course was successfully deleted'
  end

  protected
  def load_course
    @course = Course.find(params[:id])
    @course.default_market.features.build unless @course.default_market.nil?
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_courses_path, alert: 'Course not found'
  end

  def load_courses
    @courses = Course.all
    @courses.sort! { |a, b| a.name <=> b.name }
  end

  def build_course
    @course = Course.new(course_params)
  end

  def course_params
    params.require(:course).permit!
  end
end
