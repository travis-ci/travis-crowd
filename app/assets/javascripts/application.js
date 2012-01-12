// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require modernizr-custom
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require 'rest_in_place'
//= require_tree .

$('#profile').restInPlace();

var audioHost = '/sounds/';
var voices = {};

soundManager.url = '/sounds/swf/';
soundManager.waitForWindowLoad = false;
soundManager.useHTML5Audio = true;
soundManager.preferFlash = false;
soundManager.debugMode = false;
soundManager.debugFlash = false;
soundManager.flashVersion = 8;

function createSample(url, item_id) {
  var mpegURL = url + item_id + '.mp3';
  var return_value = soundManager.createSound({
    id: item_id,
    url: mpegURL,
    autoLoad: true,
    autoPlay: false,
    onload: function() {
      //console.log('The sound '+this.sID+' loaded!');
    },
    onfinish: function() {
      //console.log('finished ' + item_id);
      $('.' + item_id + ' .head.active .bubble').text('â–¶ Try me!');
      $('.' + item_id + ' .head.active').removeClass('active');
    },
    volume: 50
  });
  //console.log(return_value);
  if(!return_value) {
    //console.log('resorting to pure HTML5 audio using OGG');
    var audioElement = document.createElement('audio');
    document.body.appendChild(audioElement);
    $(audioElement).attr("preload", "auto");
    var canPlayOgg = audioElement.canPlayType("audio/ogg");
    if(canPlayOgg.match(/maybe|probably/i)) {
      audioElement.src = url + item_id + '.ogg';
      audioElement.addEventListener('ended', function(){
        $('.' + item_id + ' .head.active .bubble').text('â–¶ Try me!');
        $('.' + item_id + ' .head.active').removeClass('active');
        }, false
      );
      return_value = audioElement;
    }
  }
  return return_value;
}

soundManager.onready(function() {
  $.each(['jon', 'jose', 'aaron', 'yehuda'], function(ix, voice) {
    voices[voice] = createSample(audioHost, voice);
  })
});
