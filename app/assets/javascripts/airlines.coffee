# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->

  if $('#airline-route-map').length
    $.ajax "#{window.location.pathname}/route_map",
      type: 'GET'
      dataType: 'script'
      error: (jqXHR, textStatus, errorThrown) ->
        $('#airline-route-map').text("Unable to load route map")
        console.log("AJAX Error: #{textStatus}")
    return
