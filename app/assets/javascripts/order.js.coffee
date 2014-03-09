jQuery ($) ->
  $("#idealme-order-form").submit (event) ->
    $form.find("button").prop "disabled", true

    stripeResponseHandler = (status, response) ->
      $form = $("#idealme-order-form")
      if response.error
        # Show the errors on the form
        $form.append $("<input type=\"hidden\" name=\"stripeFailed\" />")
        $(".order-errors").append $("<div class=\"alert alert-danger alert-dismissable\" style=\"margin: 0;\"><button aria-hidden=\"true\" class=\"close\" data-dismiss=\"alert\" type=\"button\">×</button>" + response.error.message + "</div>")
        $form.find("button").prop "disabled", false
      else
        $("#idealme-order-form").off "submit"
        # token contains id, last4, and card type
        token = response.id

        # Insert the token into the form so it gets submitted to the server
        $form.append $("<input type=\"hidden\" name=\"stripeToken\" />").val(token)

        # and submit
        window.PreventExitPop = false
        $form.get(0).submit()

    addFieldError = (field) ->
      $field = $(field)
      $field.closest(".control-group").addClass "has-error"
      $field.closest(".controls").append $("<span class=\"help-inline\">can't be blank</span>")

    $form = $(this)

    # Disable the submit button to prevent repeated clicks

    email     = $form.find("#order_card_email")
    firstname = $form.find("#order_card_firstname")
    lastname  = $form.find("#order_card_lastname")
    number    = $form.find("#order_card_number")
    cvv       = $form.find("#order_card_cvv")
    exp_month = $form.find("#order_card_exp_month")
    exp_year  = $form.find("#order_card_exp_year")

    billing_address1  = $form.find("#order_card_billing_address1")
    billing_city      = $form.find("#order_card_billing_city")
    billing_zip       = $form.find("#order_card_billing_zip")
    billing_state     = $form.find("#order_card_billing_state")
    hasError  = false
    [
      email
      firstname
      lastname
      number
      cvv
      exp_month
      exp_year
      billing_address1
      billing_city
      billing_zip
      billing_state
    ].forEach (f) ->
      if f.val() is ""
        hasError = true
        addFieldError f

    if hasError
      $(".order-errors").append $("<div class=\"alert alert-danger alert-dismissable\" style=\"margin: 0;\"><button aria-hidden=\"true\" class=\"close\" data-dismiss=\"alert\" type=\"button\">×</button>There was a problem validating your information. Please ensure all your information is correct</div>")
      $form.find("button").prop "disabled", false
    else
      if window.IM_ENVIRONMENT is "test" and window.IM_USE_STRIPE isnt true
        stripeResponseHandler 200,
          id: "stripe-card-token-123123123123123123"

      else
        Stripe.card.createToken $form, stripeResponseHandler

    # Prevent the form from submitting with the default action
    false


