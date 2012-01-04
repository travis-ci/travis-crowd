Slides = (element, options) ->
  this.options = options || {}
  this.slides = element.children()
  this.current = $(this.slides[0]).addClass('current')
  this.pagination = new Pagination(element)
  this

$.extend(Slides.prototype,
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
)

Pagination = (slides) ->
  element = $('<ul class="slides-pagination"></ul>')
  slides.children().each(-> element.append('<li></li>'))
  this.dots = element.children()
  this.current = $(this.dots[0]).addClass('current')
  slides.after(element)
  this

$.extend(Pagination.prototype,
  next: ->
    this.dots.removeClass('current');
    this.current = $(this.current).next('li');
    this.current = $(this.dots[0]) if(this.current.length == 0)
    this.current.addClass('current')
)

$.fn.slides = (options) ->
  new Slides(this, options).run()

Testimonials = (element) ->
  this.element = element
  $.get('/testimonials.json', this.render.bind(this))

$.extend(Testimonials.prototype,
  render: (records) ->
    _this = this # fuck you, jquery
    $.each(records, ->
      _this.element.append($(
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
      ))
    )
)

$.fn.testimonials = ->
  new Testimonials(this)

Donator = (package, data) ->
  this.package = package
  this.data = data
  this
$.extend(Donator.prototype,
  render: ->
    tag = $('<li></li>')
    if this.isBoxed()
      tag.append($('<img src="' + (this.data.gravatar_url || '/images/anonymous.png') + '">'))
      tag.append(this.heading())
      tag.append($('<p>' + this.truncate(this.data.description) + '</p>')) if this.isDescription()
      tag.append(this.links().join(', '))
    else
      tag.append(this.heading())
    tag
  ,
  heading: ->
    '<h4>' + this.links().shift() + '</h4>'
  ,
  links: ->
    return this._links if this._links
    this._links = []
    this._links.push('<a href="' + this.data.homepage + '">' + this.data.name + '</a>') if this.data.homepage
    this._links.push('<a href="http://twitter.com/' + this.data.twitter_handle + '">@' + this.data.twitter_handle + '</a>') if this.data.twitter_handle
    this._links.push('<a href="http://github.com/' + this.data.github_handle + '">' + this.data.github_handle + '</a>') if this.data.github_handle
    this._links.push(this.data.name) if this._links.length == 0
    this._links
  ,
  isBoxed: ->
    ['medium', 'big', 'huge'].indexOf(this.package) != -1
  ,
  isDescription: ->
    ['big', 'huge'].indexOf(this.package) != -1
  ,
  lengths:
    big: 25,
    huge: 125
  ,
  truncate: (string) ->
    length = this.lengths[this.package]
    if string.length > length
      string.slice(0, length) + '&hellip;'
    else
      string
)

Donators = (package, donators) ->
  this.package = package
  this.donators = donators
  this
$.extend(Donators.prototype,
  render: ->
    _this = this
    list = $('<ul></ul>')
    $.each(this.donators, (ix, donator) ->
      list.append(new Donator(_this.package, donator).render())
    );
    return list;
)

$.fn.donators = ->
  _this = this
  $.get('/donators.json', ((data) ->
    $.each(data, (package, donators) ->
      element = $('<li class="' + package + '"></li>')
      element.append(new Donators(package, donators).render())
      _this.prepend(element)
    )
  ), 'json');

Switch = (element, callback) ->
  this.element = element
  this.labels = $('label', element)
  this.labels.click(this.switch.bind(this))
  this.callback = callback

$.extend(Switch.prototype,
  switch: ->
    this.labels.each(->
      element = $(this)
      if element.hasClass('on') then element.removeClass('on') else element.addClass('on')
    )
    console.log(this.element.find('label.on'))
    this.callback(this.element.find('label.on').attr('value')) if this.callback
)

$.fn.switch = (callback) ->
  new Switch(this, callback)
