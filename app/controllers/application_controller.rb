class ApplicationController < ActionController::API

  def current_user
    Token.find(session[:current_user_id])
  end

end
