String.prototype.camelize = ->
  this.slice(0, 1).toUpperCase() + this.slice(1)

Array.prototype.compact = ->
  _this = this
  $.each this, (ix, value) ->
    _this.splice(ix, 1) if !value

Donations = (table) ->
  this.table = table
  $.get '/donations.json', this.render.bind(this)

$.extend Donations.prototype,
  render: (data) ->
    _this = this
    $.each data, (ix, data) ->
      row = $('<tr></tr>')
      $.each new Donation(data).values(), (ix, value)->
        row.append $('<td>' + value + '</td>')
      _this.table.append(row)

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
    "<a href=\"https://github.com/#{this.user.github_handle}\" class=\"github\">Github</a>" if this.user.github_handle
  twitter: ->
    "<a href=\"https://twitter.com/#{this.user.twitter_handle}\" class=\"twitter\">Twitter</a>" if this.user.twitter_handle
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


$.fn.donations = ->
  new Donations(this)

$(document).ready ->
  $('#donations').donations()

