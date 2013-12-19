class Modals
  constructor: ->
    $(document).on 'click', '.modal-header button.close', @closeModal.bind(@)

  closeModal: (evt) ->
    $(evt.currentTarget).closest('.modal').modal('hide')
new Modals
