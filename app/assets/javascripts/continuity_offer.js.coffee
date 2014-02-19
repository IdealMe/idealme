class ContinuityOffer
  constructor: ->
    setTimeout(@showOffer, 5000)

    $(document).on "click", "#purchase-offer-btn", @purchaseOffer
    $(document).on "click", "#decline-offer-btn", @declineOffer

  showOffer: ->
    $('#offer-container').removeClass('hidden')

  purchaseOffer: ->
    $.post('/purchase-continuity-offer').then (a,b,c) ->
      console.log a
      console.log b
      console.log c

      window.location = "/thanks"

  declineOffer: ->
    #debugger
    true
new ContinuityOffer
