Playlist = (element) ->
  @element    = element
  @tbody      = $('tbody', element)
  @collection = $('tbody tr', element).toArray()
  @pagination = new Pagination(this, $('.pagination', element), @collection, 10)
  @setup()

$.extend Playlist.prototype,
  setup: ->
    $('.track a', @element).click (event)=>
      @autoplay()
      @play($(event.srcElement).attr('href'))
      false
  autoplay: ->
    soundcloud.addEventListener 'onPlayerReady', (player, data) -> player.api_play()
  play: (url) ->
    soundcloud.getPlayer('soundcloud').api_load(url)
  clear: ->
    @tbody.empty()
  render: (list)->
    @clear()
    @tbody.append(track) for track in list

$.fn.ringtones = ->
  new Playlist(playlist) for playlist in @

$ ->
  $('.playlist').ringtones()
