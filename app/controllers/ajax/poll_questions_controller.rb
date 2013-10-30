class Ajax::PollQuestionsController < Ajax::BaseController
  before_filter :require_authentication

  def show
    @poll_question = PollQuestion.where(id: params[:id]).includes(:poll_results, {poll_choices: :poll_results}).first
  end
end
