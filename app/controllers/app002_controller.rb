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
    url = url + '?' + 'keyword=' + @address2 + '&count=100&format=json'
    uri = Addressable::URI.parse(url)
    json = Net::HTTP.get(uri)
    #json = proxy_class.get(uri)
    @result2 = JSON.parse(json)
    logger.debug json

    nt = Time.now
    @result2["events"].each{|i|
      cnt = 0
      i["event"].each{|j|
        st = Time.parse(j["started_at"])
        et = Time.parse(j["ended_at"])
        if (st < nt) and (et < nt)
          logger.debug "★cnt=" + String(cnt) + "," + "nt=" + nt.to_s + "," + "st=" + st.to_s + "," + "et=" + et.to_s
          i["event"].delete_at cnt
          cnt -= 1
        else
          logger.debug "☆cnt=" + String(cnt) + "," + "nt=" + nt.to_s + "," + "st=" + st.to_s + "," + "et=" + et.to_s
          j["kikan"] = st.strftime("%Y年%m月%d日(%a)～") + et.strftime("%Y年%m月%d日(%a) (") + st.strftime("%H:%M～") + et.strftime("%H:%M)")
        end
        cnt += 1
      }
    }
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
    logger.debug @result
    
    respond_to do |format|
      format.js
		end
  end
end