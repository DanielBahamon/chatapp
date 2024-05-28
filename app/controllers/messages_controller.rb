class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat_and_application
  before_action :set_message, only: %i[show update destroy]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  # GET /applications/:application_token/chats/:chat_number/messages
  def index
    @messages = @chat.messages.order(number: :desc)
    message = @messages.empty? ? 'No messages found' : 'Messages found'

    render json: { data: @messages, message: message }, status: :ok
  end

  # GET /applications/:application_token/chats/:chat_number/messages/search?q=foo
  def search
    @messages = Message.search(params[:q])
    message = @messages.empty? ? 'No messages found' : 'Messages found'

    render json: { data: @messages, message: message }, status: :ok
  end

  # GET /applications/:application_token/chats/:chat_number/messages/:number
  def show
    render json: { data: @message, message: 'Message found' }, status: :ok
  end

  # PATCH/PUT /applications/:application_token/chats/:chat_number/messages/:number
  def update
    if @message.update(update_message_params)
      render json: { data: @message, message: 'Message updated' }, status: :ok
    else
      render json: { errors: @message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /applications/:application_token/chats/:chat_number/messages/:number
  def destroy
    return render json: { message: 'You must be logged in to delete a message' }, status: :unauthorized if current_user.nil?

    if current_user.id != @message.user_id
      render json: { message: 'You can only delete your own messages' }, status: :unauthorized
    else
      @message.destroy!
      render json: { message: 'Message deleted' }, status: :ok
    end
  end

  private

  def set_message
    @message = @chat.messages.find_by!(number: params[:number])
  end

  def set_chat_and_application
    @application = Application.find_by!(token: params[:application_token])
    @chat = @application.chats.find_by!(number: params[:chat_number])
  end

  def create_message_params
    params.require(:message).permit(:body, :username)
  end

  def update_message_params
    params.require(:message).permit(:body)
  end

  def record_not_found(error)
    render json: { message: error.message }, status: :not_found
  end
end
