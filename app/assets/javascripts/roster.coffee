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

  # Monitor the country selector and update appropriately
  if $('#roster_countries_select').length
    $('#roster_countries_select').on 'change', (event) ->
      country_id = $('#roster_countries_select option:selected').val()

      if country_id != '' # if not 'Unspecified'
        $.ajax "/api/v2/countries/#{country_id}/regions.json",
          type:     'GET',
          dataType: 'json'

          error: (jqXHR, textStatus, errorThrown) ->
            console.log("Region AJAX Error: #{textStatus}")
          success: (data, textStatus, jqXHR) ->
            $('#roster_regions_select').empty()
            $.each data, (idx, region) ->
              $('#roster_regions_select')
                .append("<option value=#{region['id']}>#{region['name']}</option>")
      else
        $('#roster_regions_select').empty()
          .append('<option value>Select country</option>')

  # Monitor the airport ident search for 4 characters
  if $('#roster_airport_ident').length
    $('#roster_airport_ident').keyup (e) ->
      $('#roster_home_airport').empty()
      $('#home_airport_id').val(null)

      if $(this).val().length >= 4
        ident = $(this).val().toUpperCase()
        $.ajax "/api/v2/airports/#{ident}.json",
          type:     'GET',
          dataType: 'json'

          error: (jqXHR, textStatus, errorThrown) ->
            console.log("Airport AJAX Error: #{textStatus}")
          success: (data, textStatus, jqXHR) ->
            $('#roster_home_airport').text( "#{data['name']} (#{data['ident']})" )
            $('#home_airport_id').val( data['id'] )

      return
    return
