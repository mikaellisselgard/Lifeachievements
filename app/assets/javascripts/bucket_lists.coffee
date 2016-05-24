# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'click', '#remove-achievement', ->
	if window.location.pathname == '/bucket_list'
		achievement = $(this).closest('#achievement-id')
		$(achievement).hide()
		return
