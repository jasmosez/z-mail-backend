require 'pp'
task :get_messages => :environment do
  
  puts "here we go"
  t1 = Time.now

  # Initialize the API
  service = Google::Apis::GmailV1::GmailService.new
  # service.client_options.application_name = APPLICATION_NAME
  service.authorization = Token.last.fresh_token
  user_id = "me"

  next_page = nil
  # ids = []
  error_counter = 0
  result_counter = 0

  begin
    puts "Fetching page of emails"
    result = service.list_user_messages(user_id, max_results: 100, page_token: next_page, q: "after:2019/12/22")

    # gather ID's for a batch
    ids = result.messages.map do |message| 
      message.id
    end

    service.batch do |service|
      ids.each do |id|
        service.get_user_message(user_id, id, format: 'metadata') do |res, err|
          if err
            # Handle error
            # puts "Error"
            error_counter += 1
          else
            # Handle response
            # date
            secs = res.internal_date/1000
            date = Time.at(secs)
        
            # id
            id = res.id

            # subject
            subject_header = res.payload.headers.find {|header| header.name == "Subject"}
            subject = subject_header.value

            # from
            from_header = res.payload.headers.find {|header| header.name == "From"}
            from = from_header.value
            
            # labels
            label_ids = res.label_ids
            
            # description
            snippet = res.snippet

            puts "id: #{id}"
            puts "date: #{date}"
            puts "subject: #{subject}"
            puts "from: #{from}"
            puts "label_ids: #{label_ids}"
            puts "snippet: #{snippet}"
            puts "--------------------------------------------"
            
            result_counter += 1
          end
        end
      end
    end
    
    next_page = result.next_page_token
  end while next_page


  

  
  t2 = Time.now
  delta = t2 - t1

  puts "#{result_counter} results"
  puts "#{error_counter} errors"
  puts "#{delta} sec"

  # ################################
  # #  parse message details
  # ################################
  # result.messages.each do |message| 
  #   message = service.get_user_message(user_id, message.id, format: 'metadata')
  #   # byebug

  #   # date
  #   secs = message.internal_date/1000
  #   date = Time.at(secs)
 
  #   # id
  #   id = message.id

  #   # subject
  #   subject_header = message.payload.headers.find {|header| header.name == "Subject"}
  #   subject = subject_header.value

  #   # from
  #   from_header = message.payload.headers.find {|header| header.name == "From"}
  #   from = from_header.value
    
  #   # labels
  #   # in/out. Out is determined by having "SENT" within label_ids. In is everything that is not out.
  #   # inbox? determined by having "INBOX" within label_ids
  #   label_ids = message.label_ids
    
  #   # description
  #   snippet = message.snippet

  #   puts "id: #{id}"
  #   puts "date: #{date}"
  #   puts "subject: #{subject}"
  #   puts "from: #{from}"
  #   puts "label_ids: #{label_ids}"
  #   puts "snippet: #{snippet}"
  #   puts "--------------------------------------------"

    
  # end

end

