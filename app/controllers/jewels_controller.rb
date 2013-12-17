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
          image: @jewel.avatar.url(:bigger), 
          link: @jewel.url,
          truncated_link: @jewel.url.truncate(50),
        }
      }
    end
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
      edit_path: goal_gem_path(@goal, jewel)
    }
  rescue ActionController::ParameterMissing => e
    render json: {error: "Missing url"}, status: 500
  rescue DuplicateJewel => e
    render json: {error: "Duplicate gem", jewel_link: goal_gem_path(e.jewel.linked_goal, e.jewel)}, status: 500
  end

  def update
    jewel = Jewel.where(owner: current_user, slug: params[:id]).first
    jewel.name = params["title"]
    jewel.kind = Jewel::TYPES[params["gemType"]]
    jewel.visible = true
    jewel.save!
    ap params
    # add comment to jewel if present
    head :ok
  end

  protected

  def load_goal
    @goal = Goal.find params[:goal_id]
  end

end
