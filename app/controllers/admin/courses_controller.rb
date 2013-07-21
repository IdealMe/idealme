class Admin::CoursesController < Admin::BaseController
  before_filter :load_course, :only => [:show, :edit, :update, :destroy]
  before_filter :load_courses, :only => :index
  before_filter :build_course, :only => [:new, :create]

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
    redirect_to admin_course_path(@category), :notice => 'Course was successfully created.'
  rescue ActiveRecord::RecordInvalid
    render :action => :new
  end

  # PUT /admin/courses/1
  def update
    @course.update_attributes!(params[:course])
    redirect_to admin_course_path(@course), :notice => 'Course was successfully updated.'
  rescue ActiveRecord::RecordInvalid
    render :action => :edit
  end

  # DELETE /admin/courses/1
  def destroy
    @course.destroy
    redirect_to admin_courses_url, :notice => 'CCourse was successfully deleted'
  end

  protected
  def load_course
    @course = Course.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_courses_path, :alert => "Course not found"
  end

  def load_courses
    @courses = Course.all
  end

  def build_course
    @course = Course.new(params[:course])
  end
end
