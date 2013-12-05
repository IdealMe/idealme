class GoalDragger
  constructor: ->
    $('div.sortable-goal-cards').sortable
      update: (event, ui) ->
        $cards = $('div.goal-user-card')
        index = 0
        data = {}
        for card in $cards
          index += 1
          $card = $(card)
          $position = $ $card.find('span.goal-position')
          $position.text("#{index}")
          data[$card.data 'id'] = index
        $.post("/ajax/goal_users/set_order", {goals: data})

$ ->
  if $('.sortable-goal-cards').length > 0
    new GoalDragger
