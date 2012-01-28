Testimonials = (element) ->
  @element = element
  @load()
  @

$.extend Testimonials,
  URL: '/testimonials.json',
  COUNT: 10

$.extend Testimonials.prototype,
  load: ()->
    $.get Testimonials.URL, (collection) =>
      @pagination = new Pagination(this, $('.pagination', @element.parent()), collection, Testimonials.COUNT)
  clear: ->
    $(@element).empty()
  render: (page) ->
    @clear()
    @element.append(new Testimonial(record).render()) for record in page
    $('#testimonials ul li:odd').addClass('even');
    $('#testimonials ul li:even').addClass('odd');

Testimonial = (data) ->
  @data = data
  @
$.extend Testimonial.prototype,
  render: ->
    $('<li>' +
      '  <img src="' + @data.image + '">' +
      '  <div>' +
      '    <blockquote>' + @data.quote + '</blockquote>' +
      '    <cite>' +
      '      <a href="' + @data.url + '">' + @data.name + '</a>,' +
      '      <a href="http://twitter.com/#!/' + @data.twitter + '">@' + @data.twitter + '</a>' +
      '    </cite>' +
      '  </div>' +
      '</li>')


$.fn.testimonials = ->
  new Testimonials(this)

$(document).ready ->
  window.testimonials = $('#testimonials ul').testimonials() if $('#testimonials').length > 0

