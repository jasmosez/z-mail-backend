class SessionsController < ApplicationController
  # layout false
  # skip_before_action :verify_authenticity_token
 

  def create
    # NEED TO UPDATE THE LOGIC HERE!
    # if the email exists in db, we are already authorized to get their email
    # set them as the current user
    # else -- go get authorization and create a new token and then set them as the current user
    # then, in any case, go get the last 30 days of emails and generate message objects for each one

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
 


end


