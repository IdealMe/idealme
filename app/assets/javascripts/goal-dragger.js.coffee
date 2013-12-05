class GoalDragger
  constructor: ->
    console.log('GoalDragger in the house')
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
          console.log "goal #{$card.find('div.goal-name').text()}"
          data[$card.data 'id'] = index
        console.log data
        $.post("/ajax/goal_users/set_order", {goals: data})


$ ->
  if $('.sortable-goal-cards').length > 0
    new GoalDragger
