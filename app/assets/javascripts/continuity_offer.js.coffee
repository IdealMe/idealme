class ContinuityOffer
  constructor: ->
    setTimeout(@showOffer, 5000)

    $(document).on "click", "#purchase-offer-btn", @purchaseOffer

  showOffer: ->
    $('#offer-container').removeClass('hidden')

  purchaseOffer: ->
    debugger
new ContinuityOffer
