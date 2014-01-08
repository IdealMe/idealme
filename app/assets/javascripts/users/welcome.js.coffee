$ ->
  $(document).on 'click', '.users-profile .alert-dismissable', ->
    $.post("/user/dismiss-welcome-message")
