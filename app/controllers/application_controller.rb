class ApplicationController < ActionController::API

  private
  
  def current_user  
    byebug
    @current_user = Token.find_by(loggedin: true)
    puts "C U R R E N T   U S E R: #{@current_user.email}"
    @current_user
  end

end
