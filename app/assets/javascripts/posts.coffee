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

$(document).on 'click', ".like", ->
  post_id = $(this).attr('id').split('-')[2]
  
  # Collect likes count div for correct post 
  likes_count = $('#likes-counter-' + post_id)

  # Split image source to collect image name 'like' and 'liked'
  image_name = $(this).find("#heart-" + post_id).attr("src").split('/')[4].split('.')[0]

  if image_name == "like"
    $(this).find("#heart-" + post_id).attr('src','http://localhost:3000/like-icons/liked.png')
    likes_count.html(Number(likes_count.html()) + 1)
  else
    $(this).find("#heart-" + post_id).attr('src', 'http://localhost:3000/like-icons/like.png')
    likes_count.html(Number(likes_count.html()) - 1)


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
  if window.location.pathname == "/" || window.location.pathname.substring(0, 14) == "/achievements/" || window.location.pathname.substring(0, 7) == "/users/"
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
    if currentScroll * 100 / windowsHeight > 95 && !started
      started = true
      scrollLoad(url, last_id)
    else
    	return
      
scrollLoad = (url, last_id) ->
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
  if window.location.pathname == "/"
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