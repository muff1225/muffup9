# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


myPosition = []
 
$(document).ready( ->
 
    getCurrent = ->
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

)


 