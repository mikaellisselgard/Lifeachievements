# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'ready page:load', ->
  $('#search_user').on 'change keyup paste', (e) ->
    $.ajax
      url: '/users/autocomplete_user_name'
      method: 'GET'
      data: 'term=' + $('#search_user').val()
      dataType: 'json'
      success: (response) ->
        if response.length != 0
          $('.user-content').children('.users').hide()
          i = 0
          while i < response.length
            obj = response[i]
            find = $('a[href$="/users/' + obj.id + '"]').parent('.users')
            find.show()
            i++
        else
          if $('#search_user').val() == ''
            $('.user-content').children('.users').show()
          else
			        $('.user-content').children('.users').hide()
			        return
		        return


  $('#search_user_form').submit (e) ->
    e.preventDefault()
    return
  return

$(document).on 'ready page:load', ->
	$('#search_user').bind 'railsAutocomplete.select', (event, data) ->
		$(location).attr('href', 'http://178.62.99.216/users/' + data.item.id)
		return

$(document).on 'ready page:load', ->
  $("#search_user").keypress (e) ->
    if e.which == 13
      $(location).attr('href', 'http://178.62.99.216/users/' + $("#search_user").val())
	return