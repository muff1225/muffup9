# coding: utf-8

class App002Controller < ApplicationController
  require 'twitter'
  include SessionsHelper

  def get_geo
    logger.debug params[:lat]
    logger.debug params[:lon]
    @lat = params[:lat]
    @lon = params[:lon]
    
    # twitterキーワード抽出
    tweetss = ''
    if session[:oauth_token]
      client = create_client
      if client
        options = {"count" => 100}
        client.user_timeline(session[:username], options).each do |res|
          tweetss = tweetss + ',' + res.text
        end
        tweetss = tweetss.gsub(/@[a-zA-Z0-9]+/, '')
        tweetss = tweetss.slice(0,1000)
        tweetss = URI.escape(tweetss)
      end
    end
    if tweetss.length > 0
      appKey = 'dj0zaiZpPWdQaVdtWGlLMDhrWCZzPWNvbnN1bWVyc2VjcmV0Jng9NzE-'
      url = 'http://jlp.yahooapis.jp/KeyphraseService/V1/extract?appid='
      url = url + appKey + '&sentence=' + tweetss + '&output=json'
      uri = URI.parse(url)
      #json = proxy_class.get(uri)
      json = Net::HTTP.get(uri)
      @result4 = JSON.parse(json)
    end
    
    # 現在地住所
    appKey = 'dj0zaiZpPWdQaVdtWGlLMDhrWCZzPWNvbnN1bWVyc2VjcmV0Jng9NzE-'
    url = 'http://reverse.search.olp.yahooapis.jp/OpenLocalPlatform/V1/reverseGeoCoder'
    url = url + '?' + 'lat=' + @lat + '&' + 'lon=' + @lon + '&' + 'appid=' + appKey + '&' + 'range=5&count=20&output=json'
    logger.debug url
    uri = URI.parse(url)
    json = Net::HTTP.get(uri)
    #json = proxy_class.get(uri)
    @result = JSON.parse(json)
    @address = @result["Feature"][0]["Property"]["Address"]
#    @address2 = @result["Feature"][0]["Property"]["AddressElement"][0]["Name"] + @result["Feature"][0]["Property"]["AddressElement"][1]["Name"] + @result["Feature"][0]["Property"]["AddressElement"][2]["Name"]
    @address2 = @result["Feature"][0]["Property"]["AddressElement"][0]["Name"] + @result["Feature"][0]["Property"]["AddressElement"][1]["Name"]
    logger.debug @address2
    
    # eventATND
    url = 'http://api.atnd.org/eventatnd/event/'
    url = url + '?' + 'keyword=' + @address2 + '&count=100&format=json'
    logger.debug url
    uri = Addressable::URI.parse(url)
    json = Net::HTTP.get(uri)
    #json = proxy_class.get(uri)
    @result2 = JSON.parse(json)
    @result7 = {}
    nt = Time.now
    if @result2["events"]
      @result2["events"].each{|i|
        i["event"].reject!{|item| (Time.parse(item["started_at"]) < nt) and (Time.parse(item["ended_at"]) < nt)}
        i["event"].each{|j|
          st = Time.parse(j["started_at"])
          et = Time.parse(j["ended_at"])
          j["kikan"] = st.strftime("%Y年%m月%d日(%a)～") + et.strftime("%Y年%m月%d日(%a) (") + st.strftime("%H:%M～") + et.strftime("%H:%M)")
        }
      }
      @result2["events"].each{|i|
        i["event"].each{|j|
          if @result4
            @result4.each{|a_key, a_value|
              if j.to_s.index(a_key)
                t_a_i = i["event"].delete(j)
                if t_a_i
                  @result7[@result7.length] = t_a_i
                end
              end
            }
          end
        }
      }
      h_count = @result7.length
      @result2["events"].each{|i|
        i["event"].each{|j|
          @result7[@result7.length] = j
          h_count += 1
          if h_count > 20
            break
          end
        }
      }
    end
    
    # ホットペッパー
    appKey = '24b486bc826adfe8'
    url = 'http://webservice.recruit.co.jp/hotpepper/gourmet/v1/'
    url = url + '?' + 'key=' + appKey + '&' + 'lat=' + @lat + '&' + 'lng=' + @lon + '&' + 'range=3&count=100&format=json'
    logger.debug url
    uri = URI.parse(url)
    json = Net::HTTP.get(uri)
    #json = proxy_class.get(uri)
    @result = JSON.parse(json)
    @result5 = {}
    @result["results"]["shop"].each{|i|
      if @result4
        @result4.each{|h_key, h_value|
          if i.to_s.index(h_key)
            t_h_i = @result["results"]["shop"].delete(i)
            if t_h_i
              @result5[@result5.length] = t_h_i
            end
          end
        }
      end
    }
    h_count = @result5.length
    @result["results"]["shop"].each{|i|
      @result5[@result5.length] = i
      h_count += 1
      if h_count > 20
        break
      end
    }
    
    # 電源検索
    url = 'http://oasis.mogya.com/api/v0/search/'
    url = url + '?' + 'lat=' + @lat +
                '&' + 'lng=' + @lon +
                '&' + 'n=' + (@lat.to_f + 0.012).to_s +
                '&' + 'w=' + (@lon.to_f - 0.012).to_s +
                '&' + 's=' + (@lat.to_f - 0.012).to_s +
                '&' + 'e=' + (@lon.to_f + 0.012).to_s
    logger.debug url
    uri = URI.parse(url)
    json = Net::HTTP.get(uri)
    #json = proxy_class.get(uri)
    @result3 = JSON.parse(json)
    @result6 = {}
    @result3["results"].each{|i|
      if @result4
        @result4.each{|d_key, d_value|
          if i.to_s.index(d_key)
            t_d_i = @result3["results"].delete(i)
            if t_d_i
              @result6[@result6.length] = t_d_i
            end
          end
        }
      end
    }
    h_count = @result6.length
    @result3["results"].each{|i|
      @result6[@result6.length] = i
      h_count += 1
      if h_count > 20
        break
      end
    }

    respond_to do |format|
      format.js
		end
  end
end