# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'click', '.notices', (e) ->
  $('#notishref').text('Notiser')
  user_id = this.id.split("-").pop()
  $.ajax({
    type: "POST",
    url: 'users/' + user_id + '/noticed/',
  });
  
  
  
  