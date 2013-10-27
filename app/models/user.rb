class User < ActiveRecord::Base
  attr_accessible :name, :provider, :uid
  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider    = auth["provider"]
      user.uid            = auth["uid"]
      user.name        = auth["info"]["name"]
      user.screen_name = auth["info"]["nickname"]
      user.token        = auth['credentials']['token']
      user.secret        = auth['credentials']['secret']

    end
  end


  def client
    Twitter::Client.new(oauth_token: token, oauth_token_secret: secret)
  end

end