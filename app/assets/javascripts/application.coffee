# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
# vendor/assets/javascripts directory can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file. JavaScript code in this file should be added after the last require_* statement.
#
# Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require rails-ujs
#= require turbolinks
#= require jquery3
#= require popper
#= require bootstrap
#= require cocoon
#= require cookieconsent.min
#= require gmap3.min
#= require leaflet
#= require Leaflet.Geodesic
#
#= require bluesky_api
#= require_tree .

$(document).on 'turbolinks:load', ->
  # Cookie Consent plugin
  window.cookieconsent.initialise
    'palette':
      'popup': 'background': '#000'
      'button': 'background': '#f1d600'
    'content':
      'href': '/policies/privacy'
    'position': 'bottom'

  # enable Bootstrap4 tooltips
  $('[data-toggle="tooltip"').tooltip()

  # remove active from all links
  unsetActive = (menu) ->
    menu.children().removeClass('active')

  # Smooth scroll to top
  $('.scroll-to-top').on 'click', (event) ->
    event.preventDefault()
    $('html, body').animate { scrollTop: 0 }, 800, ->
      window.location.hash = ''
      unsetActive($('#navbarContent').children())
      $('#nav-home').parent().addClass('active')
      return
    return

  # Smooth scroll to section
  $('.scroll-to').on 'click', (event) ->
    if (@hash != '' && window.location.pathname == '/')
      event.preventDefault()
      hash = @hash

      # remove active from all links
      unsetActive($('#navbarContent').children())

      # set clicked link parent to active
      $(@).parent().addClass('active')

      # set offset for navbar
      offset = $(hash).offset().top - 98
      $('html, body').animate { scrollTop: offset }, 800
    return
