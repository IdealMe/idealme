module Ajax::VotesHelper

  def downvoted?(instance, user)
    if instance.down_voted?(user)
      1
    else
      0
    end
  end

  def upvoted?(instance, user)
    if instance.up_voted?(user)
      1
    else
      0
    end
  end

end
