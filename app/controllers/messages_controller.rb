class MessagesController < ApplicationController

  def index
    messages = current_user.get_messages
    render json: messages
    # error handler -- google it to have the catch catch it
  end

  def show
    daysago = params[:id].to_i
    # Call get messages with the number of daysago specified by the route "id"
    messages = current_user.get_messages(daysago)
    render json: messages
  end

end
