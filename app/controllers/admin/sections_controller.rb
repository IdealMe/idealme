class Admin::SectionsController < Admin::BaseController
  # GET /admin/sections
  def index
    @sections = Section.all
  end

  # GET /admin/sections/1
  def show
    @section = Section.find(params[:id])
  end

  # GET /admin/sections/new
  def new
    @section = Section.new
  end

  # GET /admin/sections/1/edit
  def edit
    @section = Section.find(params[:id])
  end

  # POST /admin/sections
  def create
    @section = Section.new(params[:section])

    if @section.save
      redirect_to @section, notice: 'Section was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /admin/sections/1
  def update
    @section = Section.find(params[:id])

    if @section.update_attributes(params[:section])
      redirect_to @section, notice: 'Section was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /admin/sections/1
  def destroy
    @section = Section.find(params[:id])
    @section.destroy

    redirect_to sections_url
  end
end
