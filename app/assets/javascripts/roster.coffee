# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->

  # Monitor the sort selector for change and navigate appropriately
  if $('#roster-sort').length
    $('#roster-sort').on 'change', ->
      url = window.location.href.split('?')[0]
      window.location.href = url + '?sort=' + @value
      return
