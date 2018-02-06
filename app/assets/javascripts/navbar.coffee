# Custom Navbar
$(document).on 'turbolinks:load', ->
  if ($('.navbar-home')?)
    checkScroll = ->
      startY = $('.navbar-home').height() * 2
      #The point where the navbar changes in px
      if $(window).scrollTop() > startY
        # Change Navbar background color to light version
        $('.navbar-home').removeClass 'navbar-dark'
        $('.navbar-home').addClass 'navbar-light scrolled'

      else
        # Change Navbar background to dark version
        $('.navbar-home').removeClass 'navbar-light scrolled'
        $('.navbar-home').addClass 'navbar-dark'

      return

    if $('.navbar-home').length > 0
      $(window).on 'scroll load resize', ->
        checkScroll()
        return
