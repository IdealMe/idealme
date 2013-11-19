class Ajax::VotesController < Ajax::BaseController
  before_filter :require_authentication

  def up_vote
    @vote = Vote.new(vote_params)
    object = @vote.votable_type.constantize
    if object.is_votable
      instance = object.where(id: @vote.votable_id).first
      @vote = instance.up_vote(current_user)
      @vote
    end
    render json: success_payload(instance)
  end

  def down_vote
    @vote = Vote.new(vote_params)
    object = @vote.votable_type.constantize
    if object.is_votable
      instance = object.where(id: @vote.votable_id).first
      @vote = instance.down_vote(current_user)
      @vote
    end
    render json: success_payload(instance)
  end

  def un_vote
    @vote = Vote.new(vote_params)
    object = @vote.votable_type.constantize
    if object.is_votable
      instance = object.where(id: @vote.votable_id).first
      @vote = instance.un_vote(current_user)
      @vote
    end
    render json: success_payload(instance)
  end

  protected

  def success_payload(instance)
    { success: true, upvotes: instance.up_votes, downvotes: instance.down_votes, upvoted: instance.up_voted?(current_user), downvoted: instance.down_voted?(current_user) }
  end

  def vote_params
    params.require(:vote).permit!
  end
end
