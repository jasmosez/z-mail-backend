require 'net/http'
require 'json'

class Token < ApplicationRecord
  # has_many :messages

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

  def get_messages
    # Initialize the API
    service = Google::Apis::GmailV1::GmailService.new
    # service.client_options.application_name = APPLICATION_NAME
    service.authorization = self.fresh_token
    user_id = "me"

    # call to get messages. 100 per page
    result = service.list_user_messages(user_id)
    new_messages = result.messages.map do |message| 
      message = service.get_user_message(user_id, message.id, format: 'metadata')      
      new_message_hash = Message.make_message_hash(message, self)
      Message.new(new_message_hash)
    end
  end

end
