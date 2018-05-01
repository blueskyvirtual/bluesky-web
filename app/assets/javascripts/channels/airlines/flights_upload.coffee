$(document).on 'turbolinks:load', ->

  # Only subscribe to this channel if the user is on the upload page
  #
  if $('#airlines-flights-upload').length
    App.airlines_flights_upload = App.cable.subscriptions.create "Airlines::FlightsUploadChannel",
      connected: ->
        # Called when the subscription is ready for use on the server
        $('#console').append("WebSocket connected.<br/>")

      disconnected: ->
        # Called when the subscription has been terminated by the server
        $('#console').append("WebSocket disconnected.<br/>")

      received: (data) ->
        # Called when there's incoming data on the websocket for this channel
        $('#progressbar').css('width', "#{data.progress}%")
        $('#progressbar').text("#{data.progress}%")

        if data.message != null
          $('#console').append("#{data.message}<br/>")
          $('#console').animate({scrollTop: $('#console').prop("scrollHeight")}, 0);

      send_file: (data, filename) ->
        # Called from the client sending data to the server
        @perform 'send_file',
                 file_uri: data,
                 filename: filename
