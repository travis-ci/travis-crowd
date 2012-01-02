$ ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  order.setupForm()

order =
  setupForm: ->
    $('#toggle_shipping_address').change(order.toggleShippingAddress)
    $('#new_order').submit ->
      $('input[type=submit]').attr('disabled', true)
      if $('#order_card_number').length
        order.processCard()
        false
      else
        true

  toggleShippingAddress: ->
    element = $('#shipping_address')
    if element.is(':visible') then element.hide() else element.show()

  processCard: ->
    card =
      number: $('#order_card_number').val()
      cvc: $('#order_card_cvc').val()
      expMonth: $('#card_month').val()
      expYear: $('#card_year').val()
    Stripe.createToken(card, order.handleStripeResponse)

  handleStripeResponse: (status, response) ->
    console.log(status, response)
    if status == 200
      $('#user_stripe_card_token').val(response.id)
      $('#new_order')[0].submit()
    else
      $('#stripe_error').text(response.error.message)
      $('input[type=submit]').attr('disabled', false)
