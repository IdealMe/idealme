class Admin::FragmentsController < Admin::BaseController
  before_filter :load_fragment, only: [:show, :edit, :update, :destroy]
  before_filter :load_fragments, only: :index
  before_filter :build_fragment, only: [:create]

  # GET /admin/fragments
  def index
  end

  # GET /admin/fragments/1
  def show
  end

  # GET /admin/fragments/new
  def new
    @fragment = Fragment.new
  end

  # GET /admin/fragments/1/edit
  def edit
  end

  # POST /admin/fragments
  def create
    @fragment.save!
    redirect_to edit_admin_fragment_path(@fragment), notice: 'fragment was successfully created.'
  rescue ActiveRecord::RecordInvalid
    render action: :new
  end

  # PUT /admin/fragments/1
  def update
    # @fragment.update_attributes!(fragment_params)
    @fragment.name = fragment_params[:name]
    @fragment.html = fragment_params[:html]
    @fragment.description = fragment_params[:description]
    @fragment.slug = nil
    @fragment.save!

    redirect_to edit_admin_fragment_path(@fragment), notice: 'fragment was successfully updated.'
  rescue ActiveRecord::RecordInvalid
    render action: :edit
  end

  # DELETE /admin/fragments/1
  def destroy
    @fragment.destroy
    redirect_to admin_fragments_url, notice: 'fragment was successfully deleted'
  end

  protected
  def load_fragment
    @fragment = Fragment.where(id: params[:id]).first
    @fragment = Fragment.where(slug: params[:id]).first unless @fragment

  rescue ActiveRecord::RecordNotFound
    redirect_to admin_fragments_path, alert: 'fragment not found'
  end

  def load_fragments
    @fragments = Fragment.all
  end

  def build_fragment
    @fragment = Fragment.new(fragment_params)
  end

  def fragment_params
    params.require(:fragment).permit!
  end
end
