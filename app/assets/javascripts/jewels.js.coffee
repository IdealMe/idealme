class Jewels
  constructor: ->
    $(document).on 'click', '.btn-new-gem', @showAddGemModal.bind(@)
    $(document).on 'click', '.btn-post-gem', @postGem.bind(@)

  showAddGemModal: ->
    $('.new-gem-modal').modal()

  postGem: ->
    url = $('.add-gem-url-input').val()
    $.post(document.location.toString(), {
      url: url
    }).done((data) ->
      $('.new-gem-modal').modal('hide')
      $('.edit-gem-modal').modal()
      $('.edit-gem-modal .modal-title').text(data.title)
      $img = $('.edit-gem-modal .gem-image').first()
      $img.attr('src', data.image)

      $link = $('.edit-gem-modal .gem-link').first()
      $link.attr('href', data.url)
      $link.text(data.url)

    ).fail(->
      console.debug("fail yo")
    )

$ ->
  jewels = new Jewels
