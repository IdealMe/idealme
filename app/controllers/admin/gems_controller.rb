class Admin::GemsController < Admin::BaseController
  before_filter :load_gem, only: [:show, :edit, :update, :destroy]
  before_filter :load_gems, only: :index
  before_filter :build_gem, only: [:new, :create]

  # GET /admin/gems
  def index
  end

  # GET /admin/gems/1
  def show
  end

  # GET /admin/gems/new
  def new
  end

  # GET /admin/gems/1/edit
  def edit
  end

  # POST /admin/gems
  def create
    @gem.save!
    redirect_to edit_admin_gem_path(@gem), notice: 'Gem was successfully created.'
  rescue ActiveRecord::RecordInvalid
    render action: :new
  end

  # PUT /admin/gems/1
  def update
    @gem.update_attributes!(params[:jewel])
    redirect_to edit_admin_gem_path(@gem), notice: 'Gem was successfully updated.'
  rescue ActiveRecord::RecordInvalid
    render action: :edit
  end

  # DELETE /admin/gems/1
  def destroy
    @gem.destroy
    redirect_to admin_gems_url, notice: 'Gem was successfully deleted'
  end

  protected
  def load_gem
    @gem = Jewel.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_gems_path, alert: 'Gem not found'
  end

  def load_gems
    @gems = Jewel.all
  end

  def build_gem
    @gem = Jewel.new(params[:jewel])
  end
end
