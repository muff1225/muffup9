# coding: utf-8

class App002Controller < ApplicationController
  def get_geo
    logger.debug params[:lat]
    logger.debug params[:lon]
    @lat = params[:lat]
    @lon = params[:lon]

    appKey = 'dj0zaiZpPWdQaVdtWGlLMDhrWCZzPWNvbnN1bWVyc2VjcmV0Jng9NzE-'
    url = 'http://reverse.search.olp.yahooapis.jp/OpenLocalPlatform/V1/reverseGeoCoder'
    url = url + '?' + 'lat=' + @lat + '&' + 'lon=' + @lon + '&' + 'appid=' + appKey + '&' + 'output=json'
    logger.debug url
    
    uri = URI.parse(url)
    json = Net::HTTP.get(uri)
    #proxy_class = Net::HTTP::Proxy('proxy.gw.nic.fujitsu.com', 8080)
    #json = proxy_class.get(uri)
    @result = JSON.parse(json)
    
    @address = @result["Feature"][0]["Property"]["Address"]
    
#    @address2 = @result["Feature"][0]["Property"]["AddressElement"][0]["Name"] + @result["Feature"][0]["Property"]["AddressElement"][1]["Name"] + @result["Feature"][0]["Property"]["AddressElement"][2]["Name"]
    @address2 = @result["Feature"][0]["Property"]["AddressElement"][0]["Name"] + @result["Feature"][0]["Property"]["AddressElement"][1]["Name"]
    logger.debug @address2
    
    url = 'http://api.atnd.org/eventatnd/event/'
    url = url + '?' + 'keyword=' + @address2 + '&format=json'
    uri = Addressable::URI.parse(url)
    json = Net::HTTP.get(uri)
    #json = proxy_class.get(uri)
    @result2 = JSON.parse(json)
    logger.debug @result2

    appKey = '24b486bc826adfe8'
    url = 'http://webservice.recruit.co.jp/hotpepper/gourmet/v1/'
    url = url + '?' + 'key=' + appKey + '&' + 'lat=' + @lat + '&' + 'lng=' + @lon + '&' + 'range=3&format=json'
    logger.debug url
    
    uri = URI.parse(url)
    json = Net::HTTP.get(uri)
    #proxy_class = Net::HTTP::Proxy('proxy.gw.nic.fujitsu.com', 8080)
    #json = proxy_class.get(uri)
    @result = JSON.parse(json)
    
    respond_to do |format|
		format.js
	end
  end
end
