class MessagesController < ApplicationController

  def index
    messages = current_user.get_messages
    render json: messages
  end

  def show
  end

end
