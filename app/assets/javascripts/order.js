jQuery(function($) {
  $('#idealme-order-form').submit(function(event) {

    var stripeResponseHandler = function(status, response) {
      var $form = $('#idealme-order-form');

      if (response.error) {
        // Show the errors on the form
        $form.append($('<input type="hidden" name="stripeFailed" />'));
        $form.find('.payment-errors').text(response.error.message);
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

    var $form = $(this);

    // Disable the submit button to prevent repeated clicks
    $form.find('button').prop('disabled', true);

    Stripe.card.createToken($form, stripeResponseHandler);

    // Prevent the form from submitting with the default action
    return false;
  });
});
