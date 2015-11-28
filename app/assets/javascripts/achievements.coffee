# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('#search_achievement').on 'change keyup paste', (e) ->
    $.ajax
      url: '/achievements/autocomplete_achievement_description'
      method: 'GET'
      data: 'term=' + $('#search_achievement').val()
      dataType: 'json'
      success: (response) ->
        if response.length != 0
          $('.achievement-content').children('.achievements').hide()
          i = 0
          while i < response.length
            obj = response[i]
            find = $('a[href$="/achievements/' + obj.id + '"]').parent('.achievements')
            find.show()
            i++
        else
          if $('#search_achievement').val() == ''
            $('.achievement-content').children('.achievements').show()
          else
            $('.achievement-content').children('.achievements').hide()
        return
    return
  $('#search_achievement_form').submit (e) ->
    e.preventDefault()
    return
  return

$(document).on 'click', '#add-achievement', (e) ->
  e.preventDefault()
  $.ajax
    url: $(this).attr('href')
    data: $(this).serialize()
    method: 'PUT'
    success: ->
      return
  return

$(document).on 'click', '#remove-achievement', (e) ->
  e.preventDefault()
  $.ajax
    url: $(this).attr('href')
    data: $(this).serialize()
    method: 'DELETE'
    success: ->
      return
  return



	