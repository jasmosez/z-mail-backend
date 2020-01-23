class MessagesController < ApplicationController

  def index
    messages = current_user.get_messages
    byebug
    render json: messages
    # error handler -- google it to have the catch catch it
  end

  def show
  end

end
