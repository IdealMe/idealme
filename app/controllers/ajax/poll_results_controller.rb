class Ajax::PollResultsController < Ajax::BaseController
  before_filter :require_authentication

  def create
    @poll_result = PollResult.new(params[:poll_result])
    unless @poll_result.save
      render json: @poll_result.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @poll_result = PollResult.where(id: params[:id]).first
    @poll_result.destroy
  end
end
