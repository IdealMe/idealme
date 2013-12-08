class Jewels
  constructor: ->
    console.debug("Jewels")

    $(document).on 'click', '.btn-new-gem', @showAddGemModal.bind(@)
    $(document).on 'click', '.btn-post-gem', @postGem.bind(@)

  showAddGemModal: ->
    console.debug(@)
    $('.new-gem-modal').modal()

  postGem: ->
    url = $('.add-gem-url-input').val()
    console.debug("postGem: #{url}")
    $.post(document.location.toString(), {
      url: url
    }).done(->
      console.debug("done yo")
    ).fail(->
      console.debug("fail yo")
    )

$ ->
  jewels = new Jewels
