class Admin::CategoriesController < Admin::BaseController
  before_filter :load_category, only: [:show, :edit, :update, :destroy]
  before_filter :load_categories, only: :index
  before_filter :build_category, only: [:new, :create]

  # GET /admin/categories
  def index
  end

  # GET /admin/categories/1
  def show
  end

  # GET /admin/categories/new
  def new
  end

  # GET /admin/categories/1/edit
  def edit
  end

  # POST /admin/categories
  def create
    @category.save!
    redirect_to edit_admin_category_path(@category), notice: 'Category was successfully created.'
  rescue ActiveRecord::RecordInvalid
    render action: :new
  end

  # PUT /admin/categories/1
  def update
    @category.update_attributes!(params[:category])
    redirect_to edit_admin_category_path(@category), notice: 'Category was successfully updated.'
  rescue ActiveRecord::RecordInvalid
    render action: :edit
  end

  # DELETE /admin/categories/1
  def destroy
    @category.destroy
    redirect_to admin_categories_url, notice: 'Category was successfully deleted'
  end

  protected
  def load_category
    @category = Category.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_categories_path, alert: 'Category not found'
  end

  def load_categories
    @categories = Category.all
  end

  def build_category
    @category = Category.new(params[:category])
  end
end
