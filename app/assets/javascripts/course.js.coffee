class ReviewWidget
  constructor: ->
    $(document).on 'click', '.icon-btn', @handleVoteClick
    $(document).on 'click', '.cancel-container', @handleCancelReview
    #@vote('course', 'hatha-yoga', 'up')


  handleVoteClick: ->
    $this = $(this)

    $container = $('#rate-this-course-container')
    voted = $container.find('[data-voted="1"]').length > 0
    if voted
      $container.addClass('expanded')
    else
      $container.removeClass('expanded')

    #debugger

  handleCancelReview: ->
    $this = $(this)
    $container = $('#rate-this-course-container')
    $container.removeClass('expanded')

  vote: (votableType, votableId, vote) ->
    $.post("/ajax/votes/#{vote}_vote", {
      "vote": {
        "votable_type": votableType
        "votable_id": votableId
      }
    })

new ReviewWidget