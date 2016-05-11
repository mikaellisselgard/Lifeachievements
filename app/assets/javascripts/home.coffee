# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'click', '.notices', (e) ->
  $('#notishref').html('<img src="/notice_icon_white.png" height="37" width="37">')
  user_id = this.id.split("-").pop()
  $.ajax({
    type: "POST",
    url: 'users/' + user_id + '/noticed/',
  });
  