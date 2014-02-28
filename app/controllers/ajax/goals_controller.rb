class Ajax::GoalsController < Ajax::BaseController
  def index
    set_status_and_error('Invalid Parameters', 403) unless params[:q]
    @goals = Goal.where('name LIKE ?', "%#{params[:q]}%")
  end

  def show
    @goal = Goal.find(params[:id])
  end
end
