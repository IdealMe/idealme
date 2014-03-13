class ContinuityOffer
  constructor: ->
    setTimeout(@showOffer, (16 * 60 * 1000 + 20 * 1000))

    $(document).on "click", "#purchase-offer-btn, .purchase-offer-btn-2", @purchaseOffer
    $(document).on "click", "#decline-offer-btn", @declineOffer

    $(document).on "change", "#confirm-checkbox-2", @updatePurchaseUrl

  showOffer: ->
    $('#offer-container, #form-container').removeClass('hidden')

  purchaseOffer: ->
    window.PreventExitPop = false
    $.post('/purchase-continuity-offer').then (data,b,c) ->
      if data.success == true
        window.location = data.thanks_path
      else
        $('.confirmation-container label').addClass("error")

  updatePurchaseUrl: ->
    cbv = $('#confirm-checkbox-2').get()[0].checked
    href = $('.purchase-offer-btn-2').attr('data-href')
    href = "#{href}?confirm=#{cbv}"
    $('.purchase-offer-btn-2').attr('href', href)
    alert($('.purchase-offer-btn-2').attr('href'))

  declineOffer: ->
    window.PreventExitPop = false
    true

new ContinuityOffer
