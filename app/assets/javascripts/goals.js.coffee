class Goals
  constructor: ->
    $(document).on 'click', '.picker-btn', @toggleGoal.bind(@)

  toggleGoal: (evt) ->
    btn = $(evt.currentTarget)
    picker = btn.closest('.picker')
    btns = picker.find('.picker-btn')
    gid = picker.data('goal-id')
    $.post("/ajax/goal_users/toggle_goal", {goal_id: gid}).done =>
      btns.toggleClass('hidden')

new Goals
