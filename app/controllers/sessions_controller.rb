class SessionsController < ApplicationController
  # layout false
  # skip_before_action :verify_authenticity_token

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
      
    # set the current user to the found or newly created Token id
    session[:current_user_id] = user.id
    render plain: "You're all logged in and can close this tab."
  end

  def destroy
    session[:current_user_id] = ""
  end


 


end


