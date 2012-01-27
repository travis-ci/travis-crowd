String.prototype.camelize = ->
  this.slice(0, 1).toUpperCase() + this.slice(1)

Array.prototype.compact = ->
  _this = this
  $.each this, (ix, value) ->
    _this.splice(ix, 1) if !value

Donations = (table, pagination) ->
  this.tbody = $('tbody', table)
  this.pagination = new Pagination(this, pagination, Donations.COUNT)
  this.load()

$.extend Donations,
  URL: '/donations.json'
  COUNT: 10

$.extend Donations.prototype,
  load: ()->
    $.get Donations.URL, this.render.bind(this)
  clear: ->
    $(this.tbody).empty()
  render: (collection) ->
    _this = this
    this.collection = collection if collection
    this.clear()
    this.pagination.update()

    $.each this.pagination.collection(), (ix, record) ->
      row = $('<tr></tr>')
      $.each new Donation(record).values(), (ix, value)->
        row.append $('<td>' + value + '</td>')
      _this.tbody.append(row)

Donation = (data) ->
  this.data = data
  this.user = data.user
  this

$.extend Donation.prototype,
  values: ->
    _this = this
    names = ['gravatar', 'links', 'amount', 'package', 'date', 'comment']
    $.map names, (name) ->
      _this[name]()
  gravatar: ->
    '<img src="' + this.user.gravatar_url + '">'
  links: ->
    [this.name(), this.github(), this.twitter()].compact().join('')
  name: ->
    if this.user.homepage
      "<a href=\"#{this.user.homepage}\">#{this.user.name}</a>"
    else
      this.user.name
  github: ->
    "<a href=\"https://github.com/#{this.user.github_handle}\" class=\"github\">#{this.user.github_handle}</a>" if this.user.github_handle
  twitter: ->
    "<a href=\"https://twitter.com/#{this.user.twitter_handle}\" class=\"twitter\">#{this.user.twitter_handle}</a>" if this.user.twitter_handle
  amount: ->
    '$' + this.data.total
  package: ->
    "<span class=\"package #{this.data.package}\">#{this.data.package.camelize()}</span>" + this.subscription()
  subscription: ->
    if this.data.subscription then '<span class="subscription" title="subscription">yes</span>' else ''
  date: ->
    new Date(this.data.created_at).format('mediumDate')
  comment: ->
    this.data.comment


$.fn.donations = ()->
  new Donations(this, $('.pagination', this))

$(document).ready ->
  if $('#donations').length > 0
    $('#donations').donations()

    thanks  = ["Wow, thank you!", "Thank you so much!", "This puts a huge :D on our face.", "You rock!"]
    pusher  = new Pusher($('meta[name=pusher-key]').attr('content'))
    channel = pusher.subscribe 'orders_channel'

    channel.bind 'new_order', (data) ->
      order   = data.order
      user    = order.user
      message = thanks.shift()

      thanks.push(message)
      Notifier.notify "#{user.name} just donated $#{order.total}", message, user.gravatar_url, 10000
