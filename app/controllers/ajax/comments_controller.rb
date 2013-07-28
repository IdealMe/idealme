class Ajax::CommentsController < Ajax::BaseController
  before_filter :build_comment, :only => [:create]
  # GET /ajax/comments.json
  def index
    @comments = Comment.all
  end

  # GET /ajax/comments/1.json
  def show
    @comment = Comment.find(params[:id])
  end

  # POST /ajax/comments.json
  def create
    @comment.save!
    redirect_to(@comment.redirect_back_to) and return if @comment.redirect_back_to
  rescue ActiveRecord::RecordInvalid
    redirect_to(@comment.redirect_back_to, :alert => 'Comments can not be empty') and return if @comment.redirect_back_to
  end

  # PUT /ajax/comments/1.json
  def update
    @comment = Comment.find(params[:id])
    if @comment.update_attributes(params[:comment])
      head :no_content
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /ajax/comments/1.json
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    head :no_content
  end

  protected
  def build_comment
    @comment = Comment.new(params[:comment])

  end

end
