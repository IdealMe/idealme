class Jewels
  editURL: null
  constructor: ->
    $(document).on 'click', '.btn-new-gem', @showAddGemModal.bind(@)
    $(document).on 'click', '.btn-edit-gem', @publishGem.bind(@)
    $(document).on 'click', '.btn-post-gem', @addGem.bind(@)
    $(document).on 'click', '.modal-gem-title, .edit-title-icon', @editGemTitle.bind(@)
    $(document).on 'click', '.view-gem-link', @showGemModal.bind(@)
    $(document).on 'click', '.save-link', @saveGem.bind(@)

    $(document).on 'keypress', '.add-gem-url-input', (evt) =>
      @addGem() if evt.keyCode == 13

    $(document).on 'keypress', '.gem-comment', (evt) =>
      @publishGem() if evt.keyCode == 13


    #window.setTimeout(@testOpenGem.bind(@), 200)

  testOpenGem: ->
    $('.view-gem-link').first().trigger('click')

  testRun: ->
    @showAddGemModal()
    window.setTimeout((=>
      @addGem.apply(@)
    ), 500)

  saveGem: (evt) ->
    evt.preventDefault()

    target = $(evt.currentTarget)
    id = target.closest('[data-id]').data('id')
    path = target.closest('a').attr('href')
    console.debug(id)
    $.post(path).done (response) ->
      target.find('.icon-btn').toggleClass('hidden')

  showGemModal: (evt) ->
    evt.preventDefault()
    $('.new-gem-modal, .edit-gem-modal').modal('hide')
    $link = $(evt.currentTarget)
    $path = $link.attr('href')
    $('.view-gem-modal .modal-content').load("#{$path}/modal_content")
    $('.view-gem-modal').modal()


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
      @editURL = data.edit_path
      $('.new-gem-modal').modal('hide')
      $('.edit-gem-modal').modal()
      $('.edit-gem-modal .gem-comments').load(data.comments_path)
      $('.edit-gem-modal .modal-gem-title').text(data.truncated_title)
      $('#gem-title-input').val(data.title)
      $img = $('.edit-gem-modal .gem-image').first()
      $img.attr('src', data.image)

      $link = $('.edit-gem-modal .gem-link').first()
      $link.attr('href', data.url)
      $link.text(data.truncated_url)
      @editGemTitle() unless data.title.length > 0
    ).fail((xhr, status, error) ->
      console.debug(xhr.responseText)

      if !xhr.responseJSON
        $('.gem-unknown-error').removeClass('hide')
      else if xhr.responseJSON.error == 'Duplicate gem'
        $('.gem-exists-error').removeClass('hide')
        $('.gem-exists-error a').attr('href', xhr.responseJSON.jewel_link)
      else if xhr.responseJSON.error == 'Missing url'
        $('.missing-url-error').removeClass('hide')
    )

  publishGem: ->
    updatedGemTitle = $('#gem-title-input').first().val()
    updatedGemType = $('input[name="gem-type"]:checked').val()
    gemComment= $('input[name="gem-comment"]').val()
    putURL = @editURL
    $.ajax({
      data:
        title: updatedGemTitle
        gemType: updatedGemType
        gemComment: gemComment
      url: putURL
      type: "PUT"
    }).done((data) ->
      if data.success == true
        $('.edit-gem-modal').modal('hide')
        #document.location = document.location.toString()
      else
        $('.gem-error').removeClass('hide').text(data.error)
    ).fail(->
    )
    


$ ->
  jewels = new Jewels
