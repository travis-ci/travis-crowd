window.Pagination = (list, element, count) ->
  this.element = element
  this.list = list
  this.currentElement = $('.page .current-page', element)
  this.lastElement = $('.page .last-page', element)

  this.page = 1
  this.count = this.paged_count = count
  this.setup(['first', 'previous', 'next', 'last', 'all', 'paged'])
  this

$.extend window.Pagination.prototype,
  setup: (keys) ->
    _this = this
    $.each keys, (ix, key)->
      $('a.' + key, _this.element).click ->
        _this[key]()
        _this.list.render()
        false
  first: ->
    this.page = 1
    this.update()
  next: ->
    this.page += 1
    this.update()
  previous: ->
    this.page -= 1
    this.update()
  last: ->
    this.page = this.lastPage()
    this.update()
  all: ->
    this.page = 1
    this.count = this.length()
    this.update()
  paged: ->
    this.count = this.paged_count
    this.update()
  update: ->
    if(this.isPaged() && this.lastPage() == 1)
      this.element.hide()
    else
      this.element.show()
    this.element.toggleClass('first_page', this.isFirst())
    this.element.toggleClass('last_page', this.isLast())
    this.element.toggleClass('paged', this.isPaged())
    this.currentElement.html(this.page)
    this.lastElement.html(this.lastPage())
  isFirst: ->
    this.page == 1
  isLast: ->
    this.page == this.lastPage()
  isPaged: ->
    this.count == this.paged_count
  lastPage: ->
    page = parseInt(this.length() / this.count)
    rest = this.length() % this.count
    page + (rest > 0 ? 1 : 0)
  length: ->
    this.list.collection.length
  collection: ->
    this.list.collection.slice(this.start(), this.end())
  start: ->
    (this.page - 1) * this.count
  end: ->
    this.start() + this.count


