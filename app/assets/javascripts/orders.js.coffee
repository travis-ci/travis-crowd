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
  $('#user_name').blur ->
    name = $(this).val()
    $('#order_billing_address_attributes_name, #order_name').each ->
      $(this).val(name) if name != ''

  $('#new_order').submit ->
    $('input[type=submit]').attr('disabled', true)
    if $('#order_card_name').length
      _this.processCard()
      false
    else
      true

$.extend OrderForm.prototype,
  processCard: ->
    card =
      name: $('#order_card_name').val()
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
