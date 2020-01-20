require 'pp'
task :get_messages => :environment do
  
  # Initialize the API
  service = Google::Apis::GmailV1::GmailService.new
  # service.client_options.application_name = APPLICATION_NAME
  service.authorization = Token.last.fresh_token
  
  # Show the user's labels
  user_id = "me"
  result = service.get_user_thread(user_id, "16fb458fe29f9d45")
  # byebug
  pp result
  # puts "Threads:"
  # puts "No threads found" if result.threads.empty?
  # result.threads.each { |thread| puts "- #{thread.title}" }

end
