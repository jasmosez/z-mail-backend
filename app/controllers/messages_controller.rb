class MessagesController < ApplicationController

  def index
    Token.get_messages
    messages = Message.all
    render json: messages
  end

  def show
  end

end
