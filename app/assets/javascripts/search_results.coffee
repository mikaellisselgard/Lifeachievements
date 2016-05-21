# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'ready page:load', ->
  $('#search').autocomplete(source: (request, response) ->
    $.ajax
      url: '/search_results/autocomplete_search_result_record_string'
      data:
        filter: request.term
      jsonp: 'jsonp'
      dataType: 'jsonp'
      success: (data) ->
        response $.map(data, (el, index) ->
          {
            value: el.record_string 
            record_image: el.record_image 
            record_type: el.record_type 
            record_id: el.record_id
          }
        )
        return
    return
  ).data('ui-autocomplete')._renderItem = (ul, item) ->
    link = 'http://localhost:3000/' + item.record_type + 's/' + item.record_id 
    if (!item.id.length)
      $('<li />').data('item.autocomplete', item).append('<img width="25" height="25" src="post.png" />Inga resultat').appendTo ul
    else
      $('<li />').data('item.autocomplete', item).append('<a href=' + link + '><img width="30" height="30" src=\'' + item.record_image  + '\' />' + item.value + '</a>').appendTo ul

    #Link to record if keypress enter
    $("#search").keyup (e) ->
      if e.which == 13
        $(location).attr('href', 'http://localhost:3000/' + item.record_type + 's/' + item.record_id)
        return
  return