# This requires jQuery at least for now
$ ->
  hideFlash = ($flash) ->
    $flash.slideUp(100, -> $flash.remove())

  nukeCookie = (cookieName) ->
    yesterday = new Date()
    yesterday.setDate(yesterday.getDate() - 1)
    hostParts = window.location.hostname.split('.').reverse()
    expireHost = hostParts.shift()
    $.each hostParts, (i,part) ->
      expireHost = "#{part}.#{expireHost}"
      document.cookie = "#{cookieName}=; path=/; expires=#{yesterday}; domain=#{expireHost}"
    document.cookie = "#{cookieName}=; path=/; expires=#{yesterday}; domain="

  loadFlashFromCookies = ->
    if document.cookie && document.cookie != ''
      cookies = document.cookie.split(';')
      name = 'flash'
      cookieValue = null
      data = null

      for cookie in cookies
        cookie = jQuery.trim(cookie)
        if cookie.substring(0, name.length + 1) == (name + '=')
          cookieValue = decodeURIComponent(cookie.substring(name.length + 1).replace(/\+/g,'%20'))
          break

      try
        data = $.parseJSON(cookieValue)
      catch

      if data != null
        data_without_duplications = []
        strings_without_duplications = []
        flat_alert_container = $('.flat-alert')

        $.each data, (i, d) ->
          if $.inArray(d[1], strings_without_duplications) < 0
            strings_without_duplications.push(d[1])
            data_without_duplications.push(d)

        $.each data_without_duplications, (i, d) ->
          if (d[0] == 'banner') && (flat_alert_container.size())
            flat_alert_container.find('td:last').html(d[1])
            flat_alert_container.show()
          else
            $.flash(d[1], {type: d[0]})
        nukeCookie(name)

  $.flash = (message, options) ->

    options = $.extend({ type: 'success', timeout: 3500 }, options)

    flash = $("<div class='alert alert-dismissible alert-#{options.type}' role='alert'><a class='close' data-dismiss='alert'>×</a>#{message}</div>")

    $('#flash-messages').prepend(flash)
    flash.slideDown(100)

    flash.click ->
      hideFlash($flash) if $flash

    if options.timeout > 0
      setTimeout(
        ->
          hideFlash(flash)
        , options.timeout
      )
    return

  loadFlashFromCookies()

  $(document).ajaxSuccess (event,request,options) ->
    loadFlashFromCookies()
