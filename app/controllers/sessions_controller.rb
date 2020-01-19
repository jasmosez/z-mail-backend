class SessionsController < ApplicationController
  # layout false
  # skip_before_action :verify_authenticity_token
 
  def google
    render plain: "Hi, We Are Here"
    # render 'sessions/new.html.erb'
    # redirect_to "http://aee5a30f.ngrok.io/auth/google_oauth2"
  end

  def create
    @auth = request.env['omniauth.auth']['credentials']
    email = request.env['omniauth.auth'].info.email
    byebug
    Token.create(
      access_token: @auth['token'],
      refresh_token: @auth['refresh_token'],
      email: email,
      expires_at: Time.at(@auth['expires_at']).to_datetime)
    render plain: "head back to the other tab"
  end
 
  


  # def googleAuth
  #   # Get access tokens from the google server
  #   access_token = request.env["omniauth.auth"]
  #   user = User.from_omniauth(access_token)
  #   log_in(user)
  #   # Access_token is used to authenticate request made from the rails application to the google server
  #   user.google_token = access_token.credentials.token
  #   # Refresh_token to request new access_token
  #   # Note: Refresh_token is only sent once during the first request
  #   refresh_token = access_token.credentials.refresh_token
  #   user.google_refresh_token = refresh_token if refresh_token.present?
  #   user.save
  #   redirect_to root_path
  # end

end
