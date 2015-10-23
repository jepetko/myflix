$(function() {
    $('.payment-errors').hide();
    $('form').submit(function() {
        var $form = $(this);
        var $btn = $form.find('.sign-up-button');

        // Disable the submit button to prevent repeated clicks
        $btn.prop('disabled', true);

        var stripeResponseHandler = function(status, response) {
            if (response.error) {
                // Show the errors on the form
                $form.find('.payment-errors').text(response.error.message);
                $btn.prop('disabled', false);
                $('.payment-errors').show();
            } else {
                $('.payment-errors').hide();
                // response contains id and card, which contains additional card details
                var token = response.id;
                // Insert the token into the form so it gets submitted to the server
                $form.append($('<input type="hidden" name="stripeToken" />').val(token));
                // and submit
                $form.get(0).submit();
            }
        };

        Stripe.card.createToken({
            number: $('#card_number').val(),
            cvc: $('#card_cvc').val(),
            exp_month: $('#date_month').val(),
            exp_year: $('#date_year').val()
        }, stripeResponseHandler);

        // Prevent the form from submitting with the default action
        return false;
    });
});