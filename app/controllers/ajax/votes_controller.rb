class Ajax::VotesController < Ajax::BaseController
  before_filter :require_authentication

  def up_vote
    @vote = Vote.new(params[:vote])
    object = @vote.votable_type.constantize
    if object.is_votable
      instance = object.where(:id => @vote.votable_id).first
      @vote = instance.up_vote(current_user)
      @vote
    end
  end

  def down_vote
    @vote = Vote.new(params[:vote])
    object = @vote.votable_type.constantize
    if object.is_votable
      instance = object.where(:id => @vote.votable_id).first
      @vote = instance.down_vote(current_user)
      @vote
    end
  end

  def un_vote
    @vote = Vote.new(params[:vote])
    object = @vote.votable_type.constantize
    if object.is_votable
      instance = object.where(:id => @vote.votable_id).first
      @vote = instance.un_vote(current_user)
      @vote
    end
  end
end
