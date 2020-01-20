require 'net/http'
require 'json'

class Token < ApplicationRecord

def to_params
    {'refresh_token' => refresh_token,
    'client_id' => ENV['GOOGLE_CLIENT_ID'],
    'client_secret' => ENV['GOOGLE_CLIENT_SECRET'],
    'grant_type' => 'refresh_token'}
  end

  def request_token_from_google
    url = URI("https://oauth2.googleapis.com/token")
    Net::HTTP.post_form(url, self.to_params)
  end

  def refresh!
    response = request_token_from_google
    data = JSON.parse(response.body)
    self.update(access_token: data['access_token'],
    expires_at: Time.now + (data['expires_in'].to_i).seconds)
  end

  def expired?
    expires_at < Time.now
  end

  def fresh_token
    refresh! if expired?
    access_token
  end



end
