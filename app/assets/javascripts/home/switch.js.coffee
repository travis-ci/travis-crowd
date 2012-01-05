Switch = (element, callback) ->
  this.element = element
  this.labels = $('label', element)
  this.labels.click(this.switch.bind(this))
  this.callback = callback

$.extend Switch.prototype,
  switch: ->
    this.labels.each ->
      $(this).toggleClass('on')
    this.callback(this.element.find('label.on').attr('value')) if this.callback

$.fn.switch = (callback) ->
  new Switch(this, callback)

$(document).ready ->
  $('.switch').switch (value) ->
    $('#packages, #subscriptions').hide()
    $('#' + value).show()

