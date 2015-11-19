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
    popupDivId = "counter_info_popup-" + $(this).parent().attr("id").split("-").pop()
    outsideDivId = "counter_info-" + $(this).parent().attr("id").split("-").pop()
    popupHtml = "like-button-popup-" + $(this).parent().attr("id").split("-").pop()
    outsideHtml = "like-button-" + $(this).parent().attr("id").split("-").pop()
    if oldHtml == 'Gilla'
      $("#" + outsideHtml).find('a:first').html('Sluta gilla')
      $("#" + popupHtml).find('a:first').html('Sluta gilla')
      oldNumber = $("#" + outsideDivId).html()
      console.log oldNumber
      newNumber = Number(oldNumber) + 1
      $("#" + outsideDivId).html(newNumber)
      $("#" + popupDivId).html(newNumber)
    else
      $("#" + outsideHtml).find('a:first').html('Gilla')
      $("#" + popupHtml).find('a:first').html('Gilla')
      oldNumber = $("#" + outsideDivId).html()
      newNumber = Number(oldNumber) - 1
      $("#" + outsideDivId).html(newNumber)
      $("#" + popupDivId).html(newNumber)
    return