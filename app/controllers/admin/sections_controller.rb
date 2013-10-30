class Admin::SectionsController < Admin::BaseController
  before_filter :load_section, only: [:show, :edit, :update, :destroy]
  before_filter :load_sections, only: :index
  before_filter :build_section, only: [:new, :create]


  def sort
    params[:section].each_with_index do |id, index|
      Section.update_all({position: index+1}, {id: id})
    end
    render nothing: true
  end

  # GET /admin/sections
  def index
  end

  # GET /admin/sections/1
  def show
  end

  # GET /admin/sections/new
  def new
  end

  # GET /admin/sections/1/edit
  def edit
  end

  # POST /admin/sections
  def create
    @section.save!
    redirect_to edit_admin_course_path(@section.course), notice: 'Section was successfully created.'
  rescue ActiveRecord::RecordInvalid
    render action: :new
  end

  # PUT /admin/sections/1
  def update
    @section.update_attributes!(params[:section])
    redirect_to edit_admin_course_path(@section.course), notice: 'Section was successfully updated.'
  rescue ActiveRecord::RecordInvalid
    render action: :edit
  end

  # DELETE /admin/sections/1
  def destroy
    @section.destroy
    redirect_to admin_sections_url, notice: 'CSection was successfully deleted'
  end

  protected
  def load_section
    @section = Section.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_sections_path, alert: 'Section not found'
  end

  def load_sections
    @sections = Section.all
  end

  def build_section
    params[:section] ||= {}
    params[:section][:course_id] ||= params[:course_id] if params[:course_id].present?
    @section = Section.new(params[:section])
  end

end
