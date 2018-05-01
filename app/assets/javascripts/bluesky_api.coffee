# Library for AJAX requests with the Bluesky APIv2
#
#
$(document).on 'turbolinks:load', ->

  # Load airport UUIDs and Idents and return JSON hash
  #
  # Example:
  #   $.fn.API_AirportGet dest_id, (data) ->
  #     console.log data['ident']
  #     console.log data['name']
  #
  # data will be null if there was an error response from the API
  #
  $.fn.APIv2_Airport_Get = (id, callback) ->
    $.ajax "/api/v2/airports/#{id}.json",
      type: 'GET'
      dataType: 'json'
      success: (data) ->
        callback data
        return
      error: ->
        data = null
        callback data
        return
    return
