class SessionsController < ApplicationController
  # layout false

  def create
    # use authenticated email to check if we have a Token for that address
    email = request.env['omniauth.auth'].info.email
    user = Token.find_by(email: email)
    
    # if we do not, create a new user
    if !user
      @auth = request.env['omniauth.auth']['credentials']
      user = Token.create(
        access_token: @auth['token'],
        refresh_token: @auth['refresh_token'],
        email: email,
        expires_at: Time.at(@auth['expires_at']).to_datetime
      )
    end
    
    byebug
    # set the current user to the found or newly created Token id
    
    user.login
    render plain: "You're all logged in and can close this tab. Current User: #{current_user.email}"
  end

  def destroy
    Token.clear_logins
  end


 


end


