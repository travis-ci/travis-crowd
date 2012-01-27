Sponsors = (element, options) ->
  @element = element
  @decks   = $('ul', element)
  @current   = 0 # later ... Math.floor(Math.random() * @data().length)
  # @pagination = new Pagination(this, $('.pagination', element), ?)
  @render()
  this

$.extend Sponsors.prototype,
  collection: ->
    @decks
  render: ->
    $('> li', @element).each ->
      console.log(this)
    current = @current
    $.each @collection(), (ix)->
      $(this).each -> (if ix == current then $(this).show() else $(this).hide())
  # run: ->
  #   doRun = ->
  #     @next()
  #     @run()
  #   setTimeout(doRun.bind(@), @speed || 15000)
  # next: ->
  #   @current += 1
  #   @current = 0 if @current == @data().length
  #   @render()

$.fn.sponsors = (options) ->
  new Sponsors(@, options) #.run()

$(document).ready ->
  $('#thanks-companies .sponsors').sponsors()

