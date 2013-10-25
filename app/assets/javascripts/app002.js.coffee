# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


myPosition = []
latlon = []
 
$(document).ready( ->
 
    getCurrent = ->
      if 1 < window.location.search.length 
        query = window.location.search.substring(1)
        parameters = query.split('&')
        for key, param of parameters
          element = param.split('=')
          name = decodeURIComponent(element[0])
          value = decodeURIComponent(element[1])
          latlon[name] = decodeURIComponent(value)
        if latlon['lat']
          myPosition[0] = latlon['lat']
          if latlon['lon']
            myPosition[1] = latlon['lon']
            return postData()
      navigator.geolocation.getCurrentPosition(
        onSuccess,
        onError,
            enableHighAccuracy: true,
             timeout: 20000,
             maximumAge: 120000
      )
 
    onSuccess = (position) ->
        myPosition[0] = position.coords.latitude
        myPosition[1] = position.coords.longitude
        postData()
 
    onError = (err) ->
        switch err.code
          when 0 then message = 'Unknown error: ' + err.message
          when 1 then message = 'You denied permission to retrieve a position.'
          when 2
              $("#geoLocationAdd").html('The browser was unable to determine a position.')
              message = 'The browser was unable to determine a position: ' + err.message
          when 3 then message = 'The browser timed out before retrieving the position.'
          else message = err.message
 
    postData = ->
        $.ajax({
            url: "/app002/get_geo",
            data: 'lat=' + myPosition[0] + '&lon=' + myPosition[1]
        })
 
    $("#getLocation").click( ->
        getCurrent()
    )
    
    getCurrent()
)
