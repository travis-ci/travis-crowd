Slides = (element, options) ->
  this.options = options || {}
  this.slides = element.children()
  this.current = $(this.slides[0]).addClass('current')
  this.pagination = new Pagination(element)
  this

$.extend Slides.prototype,
  run: ->
    doRun = ->
      this.next()
      this.run()
    setTimeout(doRun.bind(this), this.options.speed || 5000)
  next: ->
    this.slides.removeClass('current')
    next = $(this.current).next('li')
    next = $(this.slides[0]) if next.length == 0
    next.fadeIn(this.options.fade)
    this.current.fadeOut(this.options.fade)
    this.current = next
    this.pagination.next()

Pagination = (slides) ->
  element = $('<ul class="slides-pagination"></ul>')
  slides.children().each(-> element.append('<li></li>'))
  this.dots = element.children()
  this.current = $(this.dots[0]).addClass('current')
  slides.after(element)
  this

$.extend Pagination.prototype,
  next: ->
    this.dots.removeClass('current')
    this.current = $(this.current).next('li')
    this.current = $(this.dots[0]) if(this.current.length == 0)
    this.current.addClass('current')

$.fn.slides = (options) ->
  new Slides(this, options).run()

$(document).ready ->
  $('.slides').slides
    speed: 4000
    fade: 800

