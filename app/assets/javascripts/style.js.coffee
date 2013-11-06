$ ->
  $(".select2").select2({
    width: 'resolve'
    matcher: (term, text) ->
      text = text.toUpperCase()
      term = term.toUpperCase()
      aText = []
      aTerm = []
      for i in [0..(text.length-1)]
        aText.push(text.charAt(i))
      for i in [0..(term.length-1)]
        aTerm.push(term.charAt(i))


      aText = aText.sort()
      aTerm = aTerm.sort()
      if term.length <= 2
        return true
      for letter in aTerm
        if aText.indexOf(letter) == -1
          console.debug('early retunr')
          return false
      return true
  })

  $(".goal-privacy-toggle").click ->
    self = $(this)
    data_goal_user_id = self.attr("data-goal-user-id")
    data_goal_user_private = self.attr("data-goal-user-private")
    if data_goal_user_private is 1
      self.attr "data-goal-user-private", 0
      self.html "Public"
    else
      self.attr "data-goal-user-private", 1
      self.html "Private"
    $.ajax
      type: "POST"
      url: "/ajax/goal_users/set_privacy"
      data:{ goal_user_id: data_goal_user_id }

      #success: success,
      dataType: "json"

  $(".user-avatar").click ->
    user_menu = $(this).siblings(".user-menu")
    $this = $(this)
    if $this.hasClass("on")
      $this.removeClass "on"
      user_menu.hide()
    else
      $this.addClass "on"
      user_menu.show()

  $.stayInWebApp()

  #placeholder for form
  $("input, textarea").focus ->
    if $(this).attr("placeholder") is $(this).val()
      $(this).val ""
      $(this).data "placeholder", $(this).attr("placeholder")
      $(this).attr "placeholder", ""

  $("input, textarea").blur ->
    if $(this).val() is ""
      $(this).val $(this).data("placeholder")
      $(this).attr "placeholder", $(this).data("placeholder")

  $(".flexslider").flexslider
    animation: "slide"
    controlNav: true
    manualControls: ".control-nav button"

  $(".sortable").sortable
    axis: "y"
    handle: ".handle"
    update: ->
      console.log $(this).sortable("serialize")
      $.post $(this).data("update-url"), $(this).sortable("serialize")