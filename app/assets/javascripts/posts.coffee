# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'ready page:load', ->
  $('#masonry-container').imagesLoaded ->
    $('#masonry-container').masonry
      itemSelector: '.box'
      columnWidth: 318.3333
      gutterWidth: 0
	  isFitWidth: true
	  return
	
$(document).on 'ready page:load', ->
  $('.post_image_img').load ->
    image_h = this.height
    image_w = this.width
	alert image_h
	$(this).prev('.post_image').height image_h
	$(this).prev('.post_image').width image_w
	return
	return
	
$(window).on('resize', ->
  $('.post_image_img').trigger 'load'
  #Trigger load event of image
  return
).trigger 'resize'