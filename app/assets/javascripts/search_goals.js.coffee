class SearchGoals
  constructor: ->
    url = document.location.toString()
    if url.indexOf '/searches' > -1
      $(document).on 'search-input-goal', '.search-goal-card-input', ->
        # send a post to add or remove this goal for current user
        gid = $(this).data('goal_id')
        $.post("/goals/#{gid}/toggle", (response) ->
        )

      

sg = new SearchGoals()



