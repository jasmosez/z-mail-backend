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
 

  def self.get_messages
    # Initialize the API
    service = Google::Apis::GmailV1::GmailService.new
    # service.client_options.application_name = APPLICATION_NAME
    service.authorization = Token.last.fresh_token
    user_id = "me"

    # call to get messages. 100 per page
    result = service.list_user_messages(user_id)
    result.messages.each do |message| 
      message = service.get_user_message(user_id, message.id, format: 'metadata')      
      new_message_hash = Token.make_message_hash(message)
      # byebug
      new_message = Message.new(new_message_hash)

      # output to terminal
      # puts "id: #{new_message.id}"
      # puts "date: #{new_message.date}"
      # puts "subject: #{new_message.subject}"
      # puts "from: #{new_message.from}"
      # puts "label_ids: #{new_message.label_ids}"
      # puts "snippet: #{new_message.snippet}"
      # puts "--------------------------------------------"
    end
  end

  def self.make_message_hash(message)
      message_hash = {}

      # date
      message_hash[:date] = Time.at(message.internal_date/1000)
  
      # id
      message_hash[:google_id] = message.id

      # subject
      subject_header = message.payload.headers.find do |header|
        header.name == "Subject"
      end
      message_hash[:subject] = subject_header.value

      # from
      from_header = message.payload.headers.find do |header|    
        header.name == "From"
      end
      message_hash[:from] = from_header.value

      # description
      message_hash[:snippet] = message.snippet
      
      # labels
      # in/out. Out is determined by having "SENT" within label_ids. In is everything that is not out.
      # inbox? determined by having "INBOX" within label_ids
      message.label_ids.each do |label_id|
        Label.new(google_id: message.id, name: label_id)
        # message_hash[:label_ids]
      end

      # need to include a Token identifier of some sort. Could be the db ID. Could be somethign else?
      message_hash[:token_id] = Token.last.id
  
      return message_hash
      # byebug
  end

end
