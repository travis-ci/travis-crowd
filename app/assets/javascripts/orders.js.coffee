$ ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  new OrderForm

  $('.hint').closest('.input').find('input, textarea').tipsy
    gravity: 'w'
    offset: 5
    delayIn: 100
    title: ->
      $(this).parent().find('.hint').html()

OrderForm = ->
  _this = this
  $('#new_order').submit ->
    $('input[type=submit]').attr('disabled', true)
    if $('#order_card_number').length
      _this.processCard()
      false
    else
      true
    false

$.extend OrderForm.prototype,
  processCard: ->
    card =
      number: $('#order_card_number').val()
      cvc: $('#order_card_cvc').val()
      expMonth: $('#card_month').val()
      expYear: $('#card_year').val()
    Stripe.createToken(card, this.handleStripeResponse)

  handleStripeResponse: (status, response) ->
    if status == 200
      $('#user_stripe_card_token').val(response.id)
      $('#new_order')[0].submit()
    else
      $('#stripe_error').text(response.error.message)
      $('input[type=submit]').attr('disabled', false)
