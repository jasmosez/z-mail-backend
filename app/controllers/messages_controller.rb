class MessagesController < ApplicationController

  def index
    byebug
    messages = current_user.get_messages
    render json: messages
    # error handler -- google it to have the catch catch it
  end

  def show
  end

end
