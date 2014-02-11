jQuery(function($) {
  $('#idealme-order-form').submit(function(event) {

    var stripeResponseHandler = function(status, response) {
      var $form = $('#idealme-order-form');
      if (response.error) {
        // Show the errors on the form
        $form.append($('<input type="hidden" name="stripeFailed" />'));
        $('.order-errors').append($('<div class="alert alert-danger alert-dismissable" style="margin: 0;"><button aria-hidden="true" class="close" data-dismiss="alert" type="button">×</button>' + response.error.message + '</div>'))
        $form.find('button').prop('disabled', false);
      } else {
        // token contains id, last4, and card type
        var token = response.id;
        // Insert the token into the form so it gets submitted to the server
        $form.append($('<input type="hidden" name="stripeToken" />').val(token));
        // and submit
        $form.get(0).submit();
      }
    };

    var addFieldError = function(field) {
      var $field = $(field);
      $field.closest('.control-group').addClass("has-error");
      $field.closest('.controls').append($('<span class="help-inline">can\'t be blank</span>'));
    };

    var $form = $(this);

    // Disable the submit button to prevent repeated clicks
    $form.find('button').prop('disabled', true);

    var email      = $form.find('#order_card_email');
    var firstname  = $form.find('#order_card_firstname');
    var lastname   = $form.find('#order_card_lastname');
    var number     = $form.find('#order_card_number');
    var cvv        = $form.find('#order_card_cvv');
    var exp_month  = $form.find('#order_card_exp_month');
    var exp_year   = $form.find('#order_card_exp_year');
    var hasError   = false;
    [email, firstname, lastname, number, cvv, exp_month, exp_year].forEach(function(f) {
      if (f.val() === "") {
        hasError = true;
        addFieldError(f);
      }
    });
    if (hasError) {
      $('.order-errors').append($('<div class="alert alert-danger alert-dismissable" style="margin: 0;"><button aria-hidden="true" class="close" data-dismiss="alert" type="button">×</button>There was a problem validating your information. Please ensure all your information is correct</div>'))
      $form.find('button').prop('disabled', false);
    } else {
      Stripe.card.createToken($form, stripeResponseHandler);
    }

    // Prevent the form from submitting with the default action
    return false;
  });
});
