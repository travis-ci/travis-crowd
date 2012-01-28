Sponsors = (element, options) ->
  @element = element
  @load()
  @
$.extend Sponsors,
  PACKAGES: ['platinum', 'gold', 'silver']
  SPEED: 15000
$.extend Sponsors.prototype,
  load: ->
    $.get '/sponsors.json', (sponsors) =>
      @pagination = new Pagination(this, $('.pagination', @element.parent()), @decksFrom(sponsors), 1)
  clear: ->
    @element.empty()
  render: (page) ->
    @clear()
    @element.append(deck.render()) for deck in page
  decksFrom: (sponsors) ->
    @shuffle(sponsors)
    isEmpty = (sponsors) ->
      (sponsors[key].length == 0 for key of sponsors).reduce (result, value) -> result && value
    decks = []
    decks.push(@deckFrom(sponsors)) while !isEmpty(sponsors)
    decks
  deckFrom: (sponsors) ->
    new Deck
      platinum: sponsors['platinum'].splice(0, 1),
      gold:     sponsors['gold'    ].splice(0, 2),
      silver:   sponsors['silver'  ].splice(0, 4)
  shuffle: (sponsors) ->
    order = (lft, rgt)->
      if lft.url && rgt.url then Math.round(Math.random()) - 0.5 else if lft.url then -1 else 1
    sponsors[package] = sponsors[package].sort(order) for package in Sponsors.PACKAGES
    sponsors
  run: ->
    doRun = ->
      @pagination.next()
      @run()
    setTimeout(doRun.bind(@), @speed || Sponsors.SPEED)


Deck = (data) ->
  @data = data
  @
$.extend Deck.prototype,
  render: ->
    node = $('<li></li>')
    node.append(new Package(package, @data[package]).render()) for package of @data
    node

Package = (package, sponsors) ->
  @package = package
  @sponsors = @fill(sponsors)
  @
$.extend Package,
  COUNTS:
    platinum: 1
    gold: 2
    silver: 4
$.extend Package.prototype,
  fill: (sponsors)->
    sponsors.push({ image: @placeholder() }) while sponsors.length < Package.COUNTS[@package]
    sponsors
  placeholder: ->
    '/images/placeholder-' + @package + '.png'
  render: ->
    node = $('<ul class="' + @package + '"></ul>')
    node.append(new Sponsor(sponsor).render()) for sponsor in @sponsors
    node

Sponsor = (data) ->
  @data = data
  @
$.extend Sponsor.prototype,
  render: ->
    node = $('<li></li>')
    node.append($('<a href="' + @data.href + '"><img src="' + @data.image + '"></a>' + @data.text))
    node

$.fn.sponsors = (options) ->
  new Sponsors(@, options).run()

$ ->
  $('#thanks-companies .sponsors').sponsors()

