class Dashboard::UpsellsController < Dashboard::ApplicationController
  before_filter :set_parent

  def index
    @upsells = @upsell_parent.upsells.includes({:market => :course})
  end

  def show
    @upsell = Upsell.where('upsells.id = ?', params[:id]).includes({:market => :course}).first
  end

  def new
    @upsell = Upsell.new
  end

  def edit
    @upsell = Upsell.find(params[:id])
  end

  def create
    @upsell = Upsell.new(params[:upsell])
    exist_upsell = Upsell.where('upsells.course_id = ? AND upsells.market_id = ?', @upsell.course_id, @upsell.market_id).includes(:course).first
    redirect_to(course_upsell_path(exist_upsell.course, exist_upsell)) and return if exist_upsell
    if @upsell.save
      redirect_to @upsell, notice: 'Upsell was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @upsell = Upsell.find(params[:id])
    if @upsell.update_attributes(params[:upsell])
      redirect_to @upsell, notice: 'Upsell was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @upsell = Upsell.find(params[:id])
    @upsell.destroy
    redirect_to upsells_url
  end

  private
  def upsell_url(upsell = nil)
    case @upsell_parent.class.name
      when 'Course'
        course_upsell_url(@upsell_parent, upsell)
    end
  end

  def upsells_url
    case @upsell_parent.class.name
      when 'Course'
        course_upsells_url
    end
  end

  def set_parent
    @upsell_parent = nil
    @upsell_parent = Course.where(:slug => params[:course_id]).first if params[:course_id]
  end
end


