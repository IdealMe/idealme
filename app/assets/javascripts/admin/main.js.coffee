$(document).on 'click', '.admin button.delete-feature', ->
  $(this).closest('.controls').find('.delete-feature-field').val('1')
  $(this).closest('.controls').fadeOut()

