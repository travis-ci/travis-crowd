Testimonials = (element) ->
  this.element = element
  $.get('/testimonials.json', this.render.bind(this))

$.extend Testimonials.prototype,
  render: (records) ->
    _this = this # fuck you, jquery
    $.each records, ->
      _this.element.append $(
        '<li>' +
        '  <img src="' + this.image + '">' +
        '  <div>' +
        '    <blockquote>' +
        '      ' + this.quote + '' +
        '    </blockquote>' +
        '    <cite>' +
        '      <a href="' + this.url + '">' + this.name + '</a>,' +
        '      <a href="http://twitter.com/#!/' + this.twitter + '">@' + this.twitter + '</a>' +
        '    </cite>' +
        '  </div>' +
        '</li>'
      )

$.fn.testimonials = ->
  new Testimonials(this)
  $(this)

$(document).ready ->
  $('#testimonials ul').testimonials() if $('#testimonials').length > 0
  # .lionbars()

