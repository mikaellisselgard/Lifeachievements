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
	
#$(document).on 'click tap touchstart', '.reveal-modal-bg', ->
  #$('[data-reveal]').foundation 'reveal', 'close'
  
$(document).on 'ready page:load', ->
  # when the load more link is clicked
  $('a.load-more').click (e) ->
    # prevent the default click action
    e.preventDefault()
    # hide load more link
    $('.load-more').hide()
    # show loading gif
    $('.loading-gif').show()
    # get the last id and save it in a variable 'last-id'
    last_id = $('.box').last().attr('data-id')
    # make an ajax call passing along our last user id
    $.ajax
      type: 'GET'
      url: $(this).attr('href')
      data: id: last_id
      dataType: 'script'
      success: ->
        items = $(this)
        masonryAdd(items)
        # hide the loading gif
        $('.loading-gif').hide()
        # show our load more link
        $('.load-more').show()
        return
    return
  return

masonryAdd = (items) ->
  setTimeout (->
    $('#masonry-container').masonry( 'reload' )
  ), 1000

	
	