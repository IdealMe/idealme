class Jewels
  editURL: null
  constructor: ->
    $(document).on 'click', '.btn-new-gem', @showAddGemModal.bind(@)
    $(document).on 'click', '.btn-edit-gem', @publishGem.bind(@)
    $(document).on 'click', '.btn-post-gem', @addGem.bind(@)
    $(document).on 'click', '.modal-gem-title, .edit-title-icon', @editGemTitle.bind(@)

    window.setTimeout(@testRun.bind(@), 500)

  testRun: ->
    @showAddGemModal()
    window.setTimeout((=>
      @addGem.apply(@)
    ), 500)

  showAddGemModal: ->
    $('.new-gem-modal').modal()

  editGemTitle: ->
    $('.not-editing-title').hide()
    $('.editing-title').removeClass('hide')
    $('#gem-title-input').focus()


  addGem: ->
    url = $('.add-gem-url-input').val()
    action = document.location.toString() + "/gems"
    $.post(action, {
      url: url
    }).done((data) =>
      console.debug(@)
      console.debug(data.edit_path)

      @editURL = data.edit_path
      $('.new-gem-modal').modal('hide')
      $('.edit-gem-modal').modal()
      $('.edit-gem-modal .modal-gem-title').text(data.truncated_title)
      $('#gem-title-input').val(data.title)
      $img = $('.edit-gem-modal .gem-image').first()
      $img.attr('src', data.image)

      $link = $('.edit-gem-modal .gem-link').first()
      $link.attr('href', data.url)
      $link.text(data.truncated_url)
      @publishGem()
    ).fail(->
      console.debug("fail yo")
    )

  publishGem: ->
    updatedGemTitle = $('#gem-title-input').first().val()
    updatedGemType = $('input[name="gem-type"]:checked').val()
    gemComment= $('input[name="gem-comment"]').val()
    putURL = @editURL
    console.debug('asdf' + putURL)
    $.ajax({
      data:
        title: updatedGemTitle
        gemType: updatedGemType
        gemComment: gemComment
      url: putURL
      type: "PUT"
    }).done((data) ->
      $('.edit-gem-modal').modal('hide')
    )


$ ->
  jewels = new Jewels
