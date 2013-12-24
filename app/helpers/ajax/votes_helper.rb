module Ajax::VotesHelper

  def downvoted?(instance, user)
    if user && instance.down_voted?(user) 
      1
    else
      0
    end
  end

  def upvoted?(instance, user)
    if user && instance.up_voted?(user)
      1
    else
      0
    end
  end

end
