String.prototype.camelize = ->
  @slice(0, 1).toUpperCase() + @slice(1)

Array.prototype.compact = ->
  $.each this, (ix, value) => @splice(ix, 1) if !value

Donations = (table, pagination) ->
  @tbody = $('tbody', table)
  @_pagination = pagination
  @load()

$.extend Donations,
  URL: '/donations.json'
  COUNT: 10

$.extend Donations.prototype,
  load: ()->
    $.get Donations.URL, (collection) =>
      @pagination = new Pagination(this, $('.pagination', @tbody.parent()), collection, Donations.COUNT)
  clear: ->
    $(@tbody).empty()
  render: (page)->
    @clear()
    @tbody.append(new Donation(record).render()) for record in page

Donation = (data) ->
  @data = data
  @user = data.user
  @

$.extend Donation.prototype,
  render: ->
    row = $('<tr></tr>')
    row.append $('<td>' + value + '</td>') for value in @values()
    row
  values: ->
    @[name]() for name in ['gravatar', 'links', 'amount', 'package', 'date', 'comment']
  gravatar: ->
    '<img src="' + @user.gravatar_url + '">'
  links: ->
    [@name(), @github(), @twitter()].compact().join('')
  name: ->
    if @user.homepage
      "<a href=\"#{@user.homepage}\">#{@user.name}</a>"
    else
      @user.name
  github: ->
    "<a href=\"https://github.com/#{@user.github_handle}\" class=\"github\">#{@user.github_handle}</a>" if @user.github_handle
  twitter: ->
    "<a href=\"https://twitter.com/#{@user.twitter_handle}\" class=\"twitter\">#{@user.twitter_handle}</a>" if @user.twitter_handle
  amount: ->
    '$' + @data.total
  package: ->
    "<span class=\"package #{@data.package}\">#{@data.package.camelize()}</span>" + @subscription()
  subscription: ->
    if @data.subscription then '<span class="subscription" title="subscription">yes</span>' else ''
  date: ->
    new Date(@data.created_at).format('mediumDate')
  comment: ->
    @data.comment


$.fn.donations = ()->
  new Donations(this)

$ ->
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
