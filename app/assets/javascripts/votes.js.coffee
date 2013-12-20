$ ->

  boolInt = (v) ->
    if v == true
      1
    else
      0

  update_votes = ($vote_controls, data) ->
    self = $(this)
    like_counter = $vote_controls.find('.upvote-total')
    dislike_counter = $vote_controls.find('.downvote-total')
    like_counter.html data.upvotes
    dislike_counter.html data.downvotes
    $vote_controls.find('.like').attr('data-voted', boolInt(data.upvoted))
    $vote_controls.find('.dislike').attr('data-voted', boolInt(data.downvoted))
    $vote_controls.trigger('vote_changed')

  $(document).on 'click', '.like', (e) ->
    self = $(this)
    $vote_controls = self.closest('.vote-controls')
    voted = self.attr("data-voted")
    votable_id = self.attr("data-id")
    votable_type = self.attr("data-type")
    like_counter = $vote_controls.find('.upvote-total')
    dislike_counter = $vote_controls.find('.downvote-total')
    if typeof votable_id isnt "undefined" and typeof votable_type isnt "undefined"
      vote = vote:
        owner_id: im_js.current_user_id
        up_vote: (self.attr("data-direction") is 1)
        down_vote: (self.attr("data-direction") is -1)
        votable_id: votable_id
        votable_type: votable_type

      voted = parseInt voted
      if voted is 1
        $.ajax
          url: "/ajax/votes/un_vote"
          async: false
          type: "POST"
          cache: false
          data: vote
          dataType: "json"
          success: (data) ->
            update_votes.apply(self, [$vote_controls, data])

      else
        $.ajax
          url: "/ajax/votes/up_vote"
          async: false
          type: "POST"
          cache: false
          data: vote
          dataType: "json"
          success: (data) ->
            update_votes.apply(self, [$vote_controls, data])


  $(document).on 'click', '.dislike', (e) ->
    self = $(this)
    $vote_controls = self.closest('.vote-controls')
    voted = self.attr("data-voted")
    votable_id = self.attr("data-id")
    votable_type = self.attr("data-type")
    like_counter = $vote_controls.find('.upvote-total')
    dislike_counter = $vote_controls.find('.downvote-total')
    if typeof votable_id isnt "undefined" and typeof votable_type isnt "undefined"
      vote = vote:
        owner_id: im_js.current_user_id
        up_vote: (self.attr("data-direction") is 1)
        down_vote: (self.attr("data-direction") is -1)
        votable_id: votable_id
        votable_type: votable_type

      voted = parseInt voted
      if voted is 1
        $.ajax
          url: "/ajax/votes/un_vote"
          async: false
          type: "POST"
          cache: false
          data: vote
          dataType: "json"
          success: (data) ->
            update_votes.apply(self, [$vote_controls, data])

      else
        $.ajax
          url: "/ajax/votes/down_vote"
          async: false
          type: "POST"
          cache: false
          data: vote
          dataType: "json"
          success: (data) ->
            update_votes.apply(self, [$vote_controls, data])



