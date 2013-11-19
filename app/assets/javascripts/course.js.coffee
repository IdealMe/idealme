class ReviewWidget
  constructor: ->
    $(document).on 'click', '.icon-btn', @handleBeginReview


  handleBeginReview: ->
    $this = $(this)
    console.debug "handle review form state here"

new ReviewWidget
