Testimonials = (element, pagination) ->
  this.element = element
  this.pagination = new Pagination(this, pagination, Testimonials.COUNT)
  this.load()
  this

$.extend Testimonials,
  URL: '/testimonials.json',
  COUNT: 10

$.extend Testimonials.prototype,
  load: ()->
    $.get Testimonials.URL, this.render.bind(this)
  clear: ->
    $(this.element).empty()
  render: (data) ->
    _this = this
    this.data = data if data
    this.clear()
    this.pagination.update()

    $.each this.pagination.data(), (ix, record) ->
      _this.element.append $(
        '<li>' +
        '  <img src="' + record.image + '">' +
        '  <div>' +
        '    <blockquote>' +
        '      ' + record.quote + '' +
        '    </blockquote>' +
        '    <cite>' +
        '      <a href="' + record.url + '">' + record.name + '</a>,' +
        '      <a href="http://twitter.com/#!/' + record.twitter + '">@' + record.twitter + '</a>' +
        '    </cite>' +
        '  </div>' +
        '</li>'
      )

$.fn.testimonials = ->
  new Testimonials(this, $('.pagination', this.parent()))

$(document).ready ->
  window.testimonials = $('#testimonials ul').testimonials() if $('#testimonials').length > 0

