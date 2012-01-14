window.Pagination = (list, element, count) ->
  this.element = element
  this.list = list
  this.page_number = $('.page .number', element)

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
    this.count = this.list.data.length
    this.update()
  paged: ->
    this.count = this.paged_count
    this.update()
  update: ->
    this.element.toggleClass('first_page', this.isFirst())
    this.element.toggleClass('last_page', this.isLast())
    this.element.toggleClass('paged', this.isPaged())
    this.page_number.html(this.page)
  isFirst: ->
    this.page == 1
  isLast: ->
    this.page == this.lastPage()
  isPaged: ->
    this.count == this.paged_count
  lastPage: ->
    page = parseInt(this.list.data.length / this.count)
    rest = this.list.data.length % this.count
    page + (rest > 0 ? 1 : 0)
  data: ->
    this.list.data.slice(this.start(), this.end())
  start: ->
    (this.page - 1) * this.count
  end: ->
    this.start() + this.count


