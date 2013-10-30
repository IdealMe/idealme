class Admin::PollsController < Admin::BaseController
  def index
    @polls = PollQuestion.all
  end

  def show
    @poll = PollQuestion.where(id: params[:id]).includes(:poll_choices).first
  end

  def new
    @poll = PollQuestion.new
    5.times { @poll.poll_choices.build }
  end

  def edit
    @poll = PollQuestion.where(id: params[:id]).includes(:poll_choices).first
    4.downto(@poll.poll_choices.length) { @poll.poll_choices.build }
  end

  def create
    @poll = PollQuestion.new(params[:poll_question])

    if @poll.save
      redirect_to admin_poll_path(@poll), notice: 'Poll was successfully created.'
    else
      render :new
    end
  end

  def update
    @poll = PollQuestion.where(id: params[:id]).includes(:poll_choices).first

    if @poll.update_attributes(params[:poll_question])
      redirect_to admin_poll_path(@poll), notice: 'Poll was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @poll = PollQuestion.where(id: params[:id]).first
    @poll.destroy

    redirect_to admin_polls_url
  end
end
