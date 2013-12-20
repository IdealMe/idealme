class Goals
  constructor: ->
    $(document).on 'click', '.goal-add-btn', @addGoal.bind(@)
    $(document).on 'click', '.goal-remove-btn', @removeGoal.bind(@)

  addGoal: (evt) ->
    btn = $(evt.currentTarget)
    gid = btn.data('goal-id')
    $.post("/ajax/goal_users/add_goal", {goal_id: gid}).done =>
      btn
        .removeClass('goal-add-btn')
        .addClass('goal-remove-btn')
        .text('Remove')


  removeGoal: (evt) ->
    btn = $(evt.currentTarget)
    gid = btn.data('goal-id')
    $.post("/ajax/goal_users/remove_goal", {goal_id: gid}).done =>
      btn
        .removeClass('goal-remove-btn')
        .addClass('goal-add-btn')
        .text('Add')


new Goals
