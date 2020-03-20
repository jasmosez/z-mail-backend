require 'net/http'
require 'json'

class Token < ApplicationRecord
  # has_many :messages

  def daysago(num)
    (DateTime.now - num).strftime("%Y/%-m/%-d")
  end

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

  def login
    Token.clear_logins
    self.update(loggedin: true)
  end

  def get_messages(daysago = 30, max_results = 500)
    puts "here we go"
    t1 = Time.now

    after_date = daysago(daysago)

    # Initialize the API
    service = Google::Apis::GmailV1::GmailService.new
    # service.client_options.application_name = APPLICATION_NAME
    service.authorization = self.fresh_token
    user_id = "me"

    
    next_page = nil
    error_counter = 0
    result_counter = 0
    error_ids = []
    messages_array = []
    message_hashes = []
  
    begin
      puts "Fetching page of emails"
      result = service.list_user_messages(user_id, max_results: max_results, page_token: next_page, q: "after:#{after_date}")

      # gather ID's for a batch
      ids = result.messages.map do |message| 
        message.id
      end

      service.batch do |service|
        puts "batching ids"
        ids.each do |id|
          service.get_user_message(user_id, id, format: 'metadata') do |res, err|
            if err
              # Handle error
              # puts "Error"
              error_ids << id
              error_counter += 1
            else
              # call to get messages. 100 per page
              messages_array << res
              result_counter += 1
            end
          end
        end
      end # service.batch
            
      next_page = result.next_page_token
    end while next_page



    t2 = Time.now
    delta = t2 - t1 
    
    puts error_ids
    puts "#{error_counter} errors"
    puts "#{result_counter} results"
    puts "#{delta} sec"
    puts "BATCHING COMPLETE"
    puts "---------------------------------"

    return_array = messages_array.map do |message|
      Message.new(Message.make_message_hash(message, self))
    end

    t3 = Time.now
    delta2 = t3 - t2
    delta_total = t3 - t1
    
    puts "MESSAGE INITIALIZING COMPLETE"
    puts "#{delta2} sec"
    puts "---------------------------------"
    puts "TOTAL FETCH: #{delta_total} sec"
    puts "---------------------------------"


    return_array
  end # def get_messages



  def self.clear_logins
    Token.all.each do |token|
      token.update(loggedin: nil)
    end
  end

  

end # class Token
