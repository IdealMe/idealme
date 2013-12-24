class JewelsController < ApplicationController
  before_filter :load_goal
  def index
    @jewels = @goal.jewels.where(visible: true)
  end

  def show
    @jewel = Jewel.find(params[:id])
    respond_to do |format|
      format.json {
        render json: { 
          name: @jewel.name, 
          truncated_name: @jewel.name.truncate(50), 
          image: @jewel.avatar.url(:bigger), 
          link: @jewel.url,
          truncated_link: @jewel.url.truncate(50),
          comments_path: comments_goal_gem_path(@jewel.linked_goal, @jewel),
        }
      }
    end
  end

  def save
    @jewel = Jewel.find(params[:id])
    if SavedJewel.where(jewel: @jewel, user: current_user).exists?
      SavedJewel.where(jewel: @jewel, user: current_user).destroy_all
      render json: { status: :destroyed }
    else
      SavedJewel.create(jewel: @jewel, user: current_user)
      render json: { status: :created }
    end
  end

  def comments
    @jewel = Jewel.find(params[:id])
    render layout: nil
  end

  def modal_content
    @jewel = Jewel.find(params[:id])
    render layout: nil
  end

  def create
    url = params.require(:url)
    jewel = Jewel.mine(current_user, url, @goal)
    render json: {
      url: jewel.url,
      truncated_url: jewel.url.truncate(50),
      image: jewel.avatar.url(:bigger),
      title: jewel.name,
      truncated_title: jewel.name.try(:truncate, 50),
      edit_path: goal_gem_path(@goal, jewel),
      comments_path: comments_goal_gem_path(@goal, jewel),
    }
  rescue ActionController::ParameterMissing => e
    render json: {error: "Missing url"}, status: 500
  rescue DuplicateJewel => e
    render json: {error: "Duplicate gem", jewel_link: goal_gem_path(e.jewel.linked_goal, e.jewel)}, status: 500
  end

  def update
    unless params["gemType"].present?
      render json: { success: false, error: "Gem type is missing" }
      return
    end
    unless params["title"].present?
      render json: { success: false, error: "Gem title is missing" }
      return
    end
    jewel = Jewel.where(owner: current_user, slug: params[:id]).first
    jewel.name = params["title"]

    jewel.kind = Jewel::TYPES[params["gemType"]]
    jewel.visible = true
    jewel.save!

    # add comment to jewel if present
    comment_content = params["gemComment"]
    unless comment_content.blank?
      comment = jewel.comments.build(owner: current_user, content: comment_content)
      comment.save!
    end
    render json: { success: true }
  end

  protected

  def load_goal
    @goal = Goal.find params[:goal_id]
  end

end
