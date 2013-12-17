class Jewels
  constructor: ->
    $(document).on 'click', '.btn-new-gem', @showAddGemModal.bind(@)
    $(document).on 'click', '.btn-edit-gem', @editGem.bind(@)
    $(document).on 'click', '.btn-post-gem', @postGem.bind(@)
    $(document).on 'click', '.modal-gem-title', @editGemTitle.bind(@)

  showAddGemModal: ->
    $('.new-gem-modal').modal()

  editGemTitle: ->
    $('.modal-gem-title').hide()
    $('#gem-title-input').removeClass('hide')


  postGem: ->
    url = $('.add-gem-url-input').val()
    $.post(document.location.toString(), {
      url: url
    }).done((data) ->
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

    ).fail(->
      console.debug("fail yo")
    )

  editGem: ->
    url = $('.add-gem-url-input').val()
    updatedTitle = $('.gem-title-input').first().val()
    debugger
    updatedGemType = $('.gem-type').first().val()
    gemComment = 'i like this thing apparently'
    $.ajax({
      data: 
        title: 'gem title'
        gemType: 'gem type'
      url: @editURL
      type: "PUT"
    }).done((data) ->
      debugger
    )


$ ->
  jewels = new Jewels
