# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#This is also implemented on achievements 
$(document).on 'ready page:change', ->
  $('img').lazyload()
  return

$(document).on 'ready page:load', ->
  $('#masonry-container').imagesLoaded ->
    $('#masonry-container').masonry
      itemSelector: '.box'
      columnWidth: 290
	  isFitWidth: true
	  return
	
$(document).on 'click', '.like', (e) ->
  $(this).html (index, oldHtml) ->
    popupDivId = "counter_info_popup-" + $(this).parent().parent().parent().attr("id").split("-").pop()
    outsideDivId = "counter_info-" + $(this).parent().parent().parent().attr("id").split("-").pop()
    popupHtml = "like-button-popup-" + $(this).parent().parent().parent().attr("id").split("-").pop()
    outsideHtml = "like-button-" + $(this).parent().parent().parent().attr("id").split("-").pop()
    if oldHtml == 'Gilla'
      $("#" + outsideHtml).find('a:first').html('Sluta gilla')
      $("#" + popupHtml).find('a:first').html('Sluta gilla')
      oldNumber = $("#" + outsideDivId).html()
      newNumber = Number(oldNumber) + 1
      if isNaN(newNumber)
        newNumber = 1
      $("#" + outsideDivId).html(newNumber)
      $("#" + popupDivId).html(newNumber)
    else
      $("#" + outsideHtml).find('a:first').html('Gilla')
      $("#" + popupHtml).find('a:first').html('Gilla')
      oldNumber = $("#" + outsideDivId).html()
      newNumber = Number(oldNumber) - 1
      if newNumber == 0
        newNumber = "Ingen"
      $("#" + outsideDivId).html(newNumber)
      $("#" + popupDivId).html(newNumber)
    return
	
#$(document).on 'click tap touchstart', '.reveal-modal-bg', ->
  #$('[data-reveal]').foundation 'reveal', 'close'
  

masonryAdd = (items) ->
  setTimeout (->
    $('#masonry-container').masonry( 'reload' )
    $('img').lazyload() #NOTE: Check if this is the correct place to put initialization in production
  ), 500

@getGeoLocation = ->
  navigator.geolocation.getCurrentPosition setGeoCookie
  return

setGeoCookie = (position) ->
  cookie_val = position.coords.latitude + '|' + position.coords.longitude
  document.cookie = 'lat_lng=' + escape(cookie_val)
  return
	
started = false
active = false

$(window).scroll ->
  if window.location.pathname == "/friends" || window.location.pathname.substring(0, 14) == "/achievements/" || window.location.pathname.substring(0, 7) == "/users/"
    url = '/posts/'
    active = true
    last_id = $('.box').last().attr('data-id')
  else if window.location.pathname == "/achievements"
    url = '/achievements/'
    active = true
    last_id = $('.achievements').last().attr('data-id')
  if active
    windowsHeight = $(document).height() - $(window).height()
    currentScroll = $(window).scrollTop()
    # scroll more than 80% of page
    if currentScroll * 100 / windowsHeight > 95 && !started &&
      started = true
      scrollLoad(url, last_id)
    else
    return
      
scrollLoad = (url, last_id) ->
  console.log('t')
  # make an ajax call passing along our last user id
  $.ajax
    type: 'GET'
    url: url
    data: scrollLoadType(last_id)
    dataType: 'script'
    success: ->
      items = $(this)
      masonryAdd(items)
      started = false
      return
  return
   
scrollLoadType = (last_id) ->
  if window.location.pathname == "/friends"
    data = { id: last_id, follow_ids: follow_ids }
  else if window.location.pathname.substring(0, 7) == "/users/"
    data = { id: last_id, user: user }
  # Load more posts for specific achievement
  else if window.location.pathname.substring(0, 14) == "/achievements/"
    data = { id: last_id, achievement: achievement }
  # Load more achievements
  else if window.location.pathname == "/achievements"
    data = { achievements: last_id }
  else
    data = { id: last_id }