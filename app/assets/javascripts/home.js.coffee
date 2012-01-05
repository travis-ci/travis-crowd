$(document).ready ->
  heads = $('#rails-core li')
  heads.click ->
    heads.removeClass('active')
    $(this).addClass('active')
    voices[$(this).attr('id')].play()
    setTimeout((-> heads.removeClass('active')), 1200)
    false

  $('.toggle').click ->
    $(this).closest('section').toggleClass('collapsed')
    false
