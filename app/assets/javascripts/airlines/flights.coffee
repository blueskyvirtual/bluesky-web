# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->

  # Updates the airport ident, name and hidden id value in the form
  # with the data hash from the API
  #
  $.fn.AirlineFlightFormAirport = (id, data) ->
    if data == null
      # Clear form values
      $("#{id}_name").val(null)
      $("#{id}_id").val(null)
    else
      # Set form values
      $("#{id}_ident").val(data['ident'])
      $("#{id}_name").val(data['name'])
      $("#{id}_id").val(data['id'])


  if $('#airline-flight-map').length
    $.ajax "#{window.location.pathname}/map",
      type: 'GET'
      dataType: 'script'
      error: (jqXHR, textStatus, errorThrown) ->
        $('#airline-flight-map').text("Unable to load map")
        console.log("AJAX Error: #{textStatus}")
    return

  if $('#airline-flight-form').length
    # On load
    origin_id = $('#origin_id').val()
    dest_id   = $('#destination_id').val()

    # fill in origin ident, name, and hidden value
    $.fn.APIv2_Airport_Get origin_id, (data) ->
      $.fn.AirlineFlightFormAirport('#origin', data)
      return

    # fill in destination ident, name, and hidden value
    $.fn.APIv2_Airport_Get dest_id, (data) ->
      $.fn.AirlineFlightFormAirport('#destination', data)
      return

    # Origin change monitor
    $('#origin_ident').keyup (e) ->
      origin_id = $('#origin_ident').val().toUpperCase()
      $.fn.APIv2_Airport_Get origin_id, (data) ->
        $.fn.AirlineFlightFormAirport('#origin', data)

    # Destination change monitor
    $('#destination_ident').keyup (e) ->
      dest_id = $('#destination_ident').val().toUpperCase()
      $.fn.APIv2_Airport_Get dest_id, (data) ->
        $.fn.AirlineFlightFormAirport('#destination', data)

  # Handle flight CSV uploades via ActionCable
  #
  if $('#airlines-flights-upload-form').length
    form = $('#airlines-flights-upload-form')

    form.submit (e) ->
      $this = $(this)
      e.preventDefault()

      if $('#file').get(0).files.length
        # disable submit
        $('#submit').attr('disabled','disabled');

        reader = new FileReader()

        # perform the following action after the file is loaded
        reader.addEventListener "loadend", ->
          filename = $('#file').get(0).files[0].name

          # send the results to the server
          App.airlines_flights_upload.send_file reader.result, filename

        # read file in base 64 format
        reader.readAsDataURL $('#file').get(0).files[0]
      else
        alert 'Please select a file before uploading'

      return false
