class Dashboard::SwipesController < Dashboard::ApplicationController
  before_filter :authenticate

  def index
    @swipes = Course.all
  end

  def show
    @tab = params[:tab]
    @tab = cookies.signed[:swipe_last_tab] if @tab.nil?
    @tab = 'video' if @tab.nil?
    cookies.signed[:swipe_last_tab] = @tab
    @base = params.except(:controller, :action, :filter)
    @swipe = Course.where(:slug => params[:id]).first
    raise(IdealMeException::RecordNotFound, 'That course does not exist') if @swipe.nil?
  end

  private
  def check_authentication
    authorize!(:access, :affiliate_tracking)
  end
end
