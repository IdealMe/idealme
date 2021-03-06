class Admin::LecturesController < Admin::BaseController
  before_filter :load_lecture, only: [:show, :edit, :update, :destroy]
  before_filter :load_lectures, only: :index
  before_filter :build_lecture, only: [:new, :create]

  def sort
    params[:lecture].each_with_index do |id, index|
      Lecture.update_all({ position: index + 1 }, { id: id })
    end
    render nothing: true
  end

  # GET /admin/lectures
  def index
    @q = Lecture.search(params[:q])
    @lectures = @q.result(distinct: true)
  end

  # GET /admin/lectures/1
  def show
  end

  def attach_payload
    @lecture = Lecture.find(params[:lecture_id])
    @payload = Payload.find(params[:payload_id])
    @lecture.payloads.push(@payload)
    @lecture.save!
    @payload_parent = @lecture
    render '_payloads', layout: nil
  end

  def new
  end

  # GET /admin/lectures/1/edit
  def edit
  end

  # POST /admin/lectures
  def create
    @lecture.save!
    redirect_to edit_admin_lecture_path(@lecture), notice: 'Lecture was successfully created.'
  rescue ActiveRecord::RecordInvalid
    render action: :new
  end

  # PUT /admin/lectures/1
  def update
    @lecture.update_attributes!(lecture_params)
    redirect_to edit_admin_lecture_path(@lecture), notice: 'Lecture was successfully updated.'
  rescue ActiveRecord::RecordInvalid
    render action: :edit
  end

  # DELETE /admin/lectures/1
  def destroy
    @lecture.destroy
    redirect_to admin_lectures_url, notice: 'CLecture was successfully deleted'
  end

  protected
  def load_lecture
    @lecture = Lecture.find(params[:id])
    @payload_parent = @lecture
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_lectures_path, alert: 'Lecture not found'
  end

  def load_lectures
    @lectures = Lecture.all
  end

  def build_lecture
    params[:lecture] ||= {}
    params[:lecture][:section_id] ||= params[:section_id] if params[:section_id].present?
    @lecture = Lecture.new(lecture_params)
    @payload_parent = @lecture
  end

  def lecture_params
    params.require(:lecture).permit!
  end
end
