# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
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