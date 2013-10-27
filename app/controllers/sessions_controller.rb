# -*- coding: utf-8 -*-
class SessionsController < ApplicationController
  require 'twitter'
  include SessionsHelper

  def create
    auth = request.env["omniauth.auth"]
      set_auth_session(auth)
      client = create_client
      options = {"count" => 20}
      client.user_timeline(session[:username], options).each do |res|
       p "#{res.from_user}: #{res.text}"
      end
      redirect_to root_url, :notice => "認証しました"
  end

  def destroy
    set_auth_session(nil)
    redirect_to root_url, :notice => "認証を外しました"
  end

  def failure
    redirect_to root_url, :alert => "認証できませんでした"
  end

  def cancel
    redirect_to root_url, :notice => "認証途中でキャンセルしました"
  end

end