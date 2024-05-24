class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat_and_application
  before_action :set_message, only: %i[ show update destroy ]

  # GET /applications/:application_token/chats/:chat_number/messages
  def index
    @messages = Message.where(chat_id: @chat.id).order(number: :desc)

    if @messages.empty?
      render json: { message: 'No messages found' }, status: :ok
    else
      render json: { data: @messages, message: 'Messages found' }, status: :ok
    end
  end

  # GET /applications/:application_token/chats/:chat_number/messages/search?q=foo
  def search
    @messages = Message.search(params[:q])

    if @messages.empty?
      render json: { message: 'No messages found' }, status: :ok
    else
      render json: { data: @messages, message: 'Messages found' }, status: :ok
    end
  end

  # GET /applications/:application_token/chats/:chat_number/messages/:number
  def show
    render json: { data: @message, message: 'Message found' }, status: :ok
  end

  # PATCH/PUT /applications/:application_token/chats/:chat_number/messages/:number
  def update
    if @message.update(update_message_params)
      render json: { data: @message, message: "Message updated" }, status: :ok
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # DELETE /applications/:application_token/chats/:chat_number/messages/:number
  def destroy
    if current_user.nil?
      return render json: { message: "You must be logged in to delete a message" }, status: :unauthorized
    end

    user = User.find_by(username: current_user.username)

    if user.id != @message.user_id
      return render json: { message: "You can only delete your own messages" }, status: :unauthorized
    else
      @message.destroy!
      render json: { message: "Message deleted" }, status: :ok
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find_by(chat_id: @chat.id, number: params[:number])

      if @message.nil?
        return render json: { message: "Message not found" }, status: :not_found
      end
    end

    def set_chat_and_application
      @application = Application.find_by(token: params[:application_token])
      if @application.nil?
        return render json: { message: "Application not found" }, status: :not_found
      end
      @chat = Chat.find_by(application_id: @application.id, number: params[:chat_number])
      if @chat.nil?
        return render json: { message: "Chat not found" }, status: :not_found
      end
    end

    # Only allow a list of trusted parameters through.
    def create_message_params
      params.require(:message).permit(:body, :username)
    end

    def update_message_params
      params.require(:message).permit(:body)
    end
end
