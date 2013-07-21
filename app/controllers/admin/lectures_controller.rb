class Admin::LecturesController < Admin::BaseController
  # GET /admin/lectures
  def index
    @lectures = Lecture.all
  end

  # GET /admin/lectures/1
  def show
    @lecture = Lecture.find(params[:id])

  end

  # GET /admin/lectures/new
  def new
    @lecture = Lecture.new
  end

  # GET /admin/lectures/1/edit
  def edit
    @lecture = Lecture.find(params[:id])
  end

  # POST /admin/lectures
  def create
    @lecture = Lecture.new(params[:lecture])

    if @lecture.save
      redirect_to admin_lecture_path(@lecture), notice: 'Lecture was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /admin/lectures/1
  def update
    @lecture = Lecture.find(params[:id])

    if @lecture.update_attributes(params[:lecture])
      redirect_to admin_lecture_path(@lecture), notice: 'Lecture was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /admin/lectures/1
  def destroy
    @lecture = Lecture.find(params[:id])
    @lecture.destroy
    redirect_to admin_lectures_url
  end

end
