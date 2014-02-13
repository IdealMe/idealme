class ContinuityOffer
  constructor: ->
    setTimeout(@showOffer, 5000)

  showOffer: ->
    $('#offer-container').removeClass('hidden')
new ContinuityOffer
