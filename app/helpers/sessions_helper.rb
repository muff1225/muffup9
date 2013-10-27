module SessionsHelper
  def signed_in?
    session[:oauth_token] != nil
  end
  def create_client
    client = Twitter::Client.new(
        :consumer_key => session[:consumer_key],
        :consumer_secret => session[:consumer_secret],
        :oauth_token => session[:oauth_token],
        :oauth_token_secret => session[:oauth_token_secret]
    )
    return client
  end

  def set_auth_session(auth)
    if auth
      session[:consumer_key] = auth.extra.access_token.consumer.key
      session[:consumer_secret] = auth.extra.access_token.consumer.secret
      session[:oauth_token] = auth.credentials.token
      session[:oauth_token_secret] = auth.credentials.secret
      session[:username] = auth.extra.access_token.params[:screen_name]
    else
      session[:consumer_key] = nil
      session[:consumer_secret] = nil
      session[:oauth_token] = nil
      session[:oauth_token_secret] = nil
      session[:username] = nil
    end
  end
end
