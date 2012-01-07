OrderForm = (form) ->
  @form = form
  _this = this
  $('#user_name').blur ->
    name = $(this).val()
    $('#order_billing_address_attributes_name, #order_card_name').each ->
      $(this).val(name) if name != ''

  form.submit ->
    if $('#order_card_name').length
      _this.processCard()
      false
    else
      _this.disable('Submitting ...')
      true

$.extend OrderForm.prototype,
  processCard: ->
    @disable('Validating your credit card ...')
    card =
      name: $('#order_card_name').val()
      number: $('#order_card_number').val()
      cvc: $('#order_card_cvc').val()
      expMonth: $('#card_month').val()
      expYear: $('#card_year').val()
    Stripe.createToken(card, @handleStripeResponse.bind(@))

  handleStripeResponse: (status, response) ->
    if status == 200
      @disable('Submitting ...')
      $('#user_stripe_card_token').val(response.id)
      @form[0].submit()
    else
      @enable()
      $('#stripe_error').text(response.error.message)

  disable: (message)->
    $('input[type=submit]').attr('disabled', true)
    $('.cancel').hide()
    $('.message').html(message).show()

  enable: ->
    $('input[type=submit]').attr('disabled', false)
    $('.cancel').show()
    $('.message').hide()

$.fn.orderForm = ->
  new OrderForm(this)

$(document).ready ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  $('#new_order').orderForm()

  $('.hint').closest('.input').find('input, textarea').tipsy
    gravity: 'w'
    offset: 5
    delayIn: 100
    title: ->
      $(this).parent().find('.hint').html()

