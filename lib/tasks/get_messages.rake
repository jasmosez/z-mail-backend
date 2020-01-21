require 'pp'
task :get_messages => :environment do
  
  # Initialize the API
  service = Google::Apis::GmailV1::GmailService.new
  # service.client_options.application_name = APPLICATION_NAME
  service.authorization = Token.last.fresh_token
  user_id = "me"

  # array of hashes that we will pass to the front end via its fetch request
  dataObj = []

  # call to get messages. 100 per page
  result = service.list_user_messages(user_id)
  result.messages.each { |message| 
    message = service.get_user_message(user_id, message.id)
    # byebug

    # date
    secs = message.internal_date/1000
    date = Time.at(secs)
 
    # id
    id = message.id

    # subject
    subject_header = message.payload.headers.find {|header| header.name == "Subject"}
    subject = subject_header.value

    # from
    from_header = message.payload.headers.find {|header| header.name == "From"}
    from = from_header.value
    
    # labels
    # in/out. Out is determined by having "SENT" within label_ids. In is everything that is not out.
    # inbox? determined by having "INBOX" within label_ids
    label_ids = message.label_ids
    
    # description
    snippet = message.snippet

    puts "id: #{id}"
    puts "date: #{date}"
    puts "subject: #{subject}"
    puts "from: #{from}"
    puts "label_ids: #{label_ids}"
    puts "snippet: #{snippet}"
    puts "--------------------------------------------"

    
  }

end


# https://mail.google.com/mail/u/0/#advanced-search/
# subset=all&within=1w&sizeoperator=s_sl&sizeunit=s_smb&date=2020%2F01%2F21