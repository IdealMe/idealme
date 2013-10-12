$ ->
  $(".select2").select2()
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

  current_user_username = im_js.current_user_username
  if typeof current_user_username isnt "undefined" and current_user_username? and not im_js.current_user_toured
    tour = new Tour(onEnd: ->
      $.ajax
        url: "/ajax/users/" + current_user_username
        async: false
        type: "PUT"
        cache: false
        data:
          user:
            toured: "1"

        dataType: "json"
        success: () ->
          window.location  = "/" + current_user_username + "/welcome"

    )
    
    #      template: "<div class='popover tour'><div class='arrow'></div><h3 class='popover-title'></h3><div class='popover-content'></div><nav class='popover-navigation'> <div class='btn-group'><button data-role='prev'>« Prev</button><button data-role='next'>Next »</button></div><button  data-role='end'>End tour</button> </nav></div>"
    tour.addSteps [
      path: "/bill"
      element: ".logo"
      placement: "bottom"
      title: "Hey Username! Welcome to Ideal Me"
      content: "Let's get you started in under a minute by showing you around..."
    ,
      path: "/bill"
      element: ".user-counters"
      placement: "bottom"
      title: "Your stats"
      content: "Track your progress, gems you collect and share, and supporters."
    ,
      element: ".goal-card:first"
      placement: "top"
      title: "Your goals"
      content: "Here are your goals. You can add more or mark them as done."
    ,
      path: "/discovers"
      element: "a.active"
      placement: "bottom"
      title: "Find inspiration and resources"
      content: "On the discover page you'll find all the latest gems, goals and courses sorted by popularity or the date they were added"
    ,
      path: "/markets"
      element: "a.active"
      placement: "bottom"
      title: "Find and buy courses you can trust"
      content: "In the marketplace you can explore featured, popular and recommended courses from IdealMe and our partners, reviewed and vetted by our members"
    ,
      path: "/bill"
      element: ".logo"
      placement: "bottom"
      title: "All done!"
      content: "Now get off to a good start by checking in for the first time..."
    ]
    
    # ,
    #        {
    #            element: "#usage",
    #            placement: "top",
    #            title: "Setup in four easy steps",
    #            content: "Easy is better, right? Easy like Bootstrap.",
    #            options: {
    #                labels: {
    #                    prev: "Go back",
    #                    next: "Hey",
    #                    end: "Stop"
    #                }
    #            }
    #        },
    #        {
    #            element: "#options",
    #            placement: "top",
    #            title: "And it is powerful!",
    #            content: "There are more options for those, like us, who want to do complicated things. " + "<br />Power to the people! :P",
    #            reflex: true
    #        },
    #        {
    #            element: "#demo",
    #            placement: "top",
    #            title: "A new shiny Backdrop option",
    #            content: "If you need to highlight the current step's element, activate the backdrop " + "and you won't lose the focus anymore!",
    #            backdrop: true
    #        },
    #        {
    #            element: "#reflex",
    #            placement: "bottom",
    #            title: "Reflex mode",
    #            content: "Reflex mode is enabled, click on the page heading to continue!",
    #            reflex: true
    #        },
    #        {
    #            path: "/page.html",
    #            element: "h1",
    #            placement: "bottom",
    #            title: "See, you are not restricted to only one page",
    #            content: "Well, nothing to see here. Click next to go back to the index page."
    #        },
    #        {
    #            path: "/",
    #            element: "#contribute",
    #            placement: "bottom",
    #            title: "Best of all, it's free!",
    #            content: "Yeah! Free as in beer... or speech. Use and abuse, but don't forget to contribute!"
    #        }
    tour.restart()

  $(".sortable").sortable
    axis: "y"
    handle: ".handle"
    update: ->
      console.log $(this).sortable("serialize")
      $.post $(this).data("update-url"), $(this).sortable("serialize")