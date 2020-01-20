require 'pp'
task :list_labels => :environment do
  
  # Initialize the API
  service = Google::Apis::GmailV1::GmailService.new
  # service.client_options.application_name = APPLICATION_NAME
  service.authorization = Token.last.fresh_token
  
  # Show the user's labels
  user_id = "me"
  result = service.list_user_labels user_id
  byebug
  puts "Labels:"
  puts "No labels found" if result.labels.empty?
  result.labels.each { |label| puts "- #{label.name}" }

end
