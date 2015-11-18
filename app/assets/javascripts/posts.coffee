# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'ready page:load', ->
  $('#masonry-container').imagesLoaded ->
    $('#masonry-container').masonry
      itemSelector: '.box'
      columnWidth: 290
	  isFitWidth: true
	  return
	
$(document).on 'click', '.like', (e) ->
  $(this).html (index, oldHtml) ->
    if oldHtml == 'Gilla'
      $(this).html('Sluta gilla')
    else
      $(this).html('Gilla')
    return