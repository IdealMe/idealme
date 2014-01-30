class Admin::ArticlesController < Admin::BaseController
  before_filter :load_article, only: [:show, :edit, :update, :destroy]
  before_filter :load_articles, only: :index
  before_filter :build_article, only: [:create]

  # GET /admin/articles
  def index
  end

  # GET /admin/articles/1
  def show
  end

  # GET /admin/articles/new
  def new
    @article = Article.new
  end

  # GET /admin/articles/1/edit
  def edit
  end

  # POST /admin/articles
  def create
    @article.save!
    redirect_to edit_admin_article_path(@article), notice: 'Article was successfully created.'
  rescue ActiveRecord::RecordInvalid
    render action: :new
  end

  # PUT /admin/articles/1
  def update
    @article.update_attributes!(article_params)
    redirect_to edit_admin_article_path(@article), notice: 'Article was successfully updated.'
  rescue ActiveRecord::RecordInvalid
    render action: :edit
  end

  # DELETE /admin/articles/1
  def destroy
    @article.destroy
    redirect_to admin_articles_url, notice: 'Article was successfully deleted'
  end

  protected
  def load_article
    @article = Article.where(slug: params[:id]).first
    @article.article_goals.build(article: @article)
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_articles_path, alert: "Article not found"
  end

  def load_articles
    @articles = Article.all
  end

  def build_article
    @article = Article.new(article_params)
  end

  def article_params
    params.require(:article).permit!
  end

end
