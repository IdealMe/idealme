$ ->

  boolInt = (v) ->
    if v == true
      1
    else
      0

  update_votes = (data) ->
    self = $(this)
    like_counter = $('.upvote-total')
    dislike_counter = $('.downvote-total')
    like_counter.html data.upvotes
    dislike_counter.html data.downvotes
    $container = self.closest('.vote-controls')
    $container.find('.like').attr('data-voted', boolInt(data.upvoted))
    $container.find('.dislike').attr('data-voted', boolInt(data.downvoted))

  $(document).on 'click', '.like', (e) ->
    self = $(this)
    voted = self.attr("data-voted")
    votable_id = self.attr("data-id")
    votable_type = self.attr("data-type")
    like_counter = $('.upvote-total')
    dislike_counter = $('.downvote-total')
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
            update_votes.apply(self, [data])

      else
        $.ajax
          url: "/ajax/votes/up_vote"
          async: false
          type: "POST"
          cache: false
          data: vote
          dataType: "json"
          success: (data) ->
            update_votes.apply(self, [data])


  $(document).on 'click', '.dislike', (e) ->
    self = $(this)
    voted = self.attr("data-voted")
    votable_id = self.attr("data-id")
    votable_type = self.attr("data-type")
    like_counter = $('.upvote-total')
    dislike_counter = $('.downvote-total')
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
            update_votes.apply(self, [data])

      else
        $.ajax
          url: "/ajax/votes/down_vote"
          async: false
          type: "POST"
          cache: false
          data: vote
          dataType: "json"
          success: (data) ->
            update_votes.apply(self, [data])



