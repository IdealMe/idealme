$ ->
  $(document).on 'click', '.users-profile .alert-dismissable', ->
    $.post("/#{im_js.current_user_username}/dismiss-welcome-message")
