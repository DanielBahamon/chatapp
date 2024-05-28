class ChatsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_application
  before_action :set_chat, only: %i[show update destroy]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  # GET /applications/:application_token/chats
  def index
    @chats = @application.chats.order(:number)
    message = @chats.empty? ? 'No chats found' : 'Chats found'

    render json: { data: @chats, message: message }, status: :ok
  end

  # GET /applications/:application_token/chats/:number
  def show
    render json: { data: @chat, message: 'Chat found' }, status: :ok
  end

  # PATCH/PUT /applications/:application_token/chats/:number
  def update
    if @chat.update(chat_params)
      render json: { data: @chat, message: 'Chat updated' }, status: :ok
    else
      render json: { errors: @chat.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /applications/:application_token/chats/:number
  def destroy
    @chat.destroy!
    render json: { message: 'Chat deleted' }, status: :ok
  end

  private

  def set_application
    @application = Application.find_by!(token: params[:application_token])
  end

  def set_chat
    @chat = @application.chats.find_by!(number: params[:number])
  end

  def chat_params
    params.require(:chat).permit!
  end

  def record_not_found(error)
    render json: { message: error.message }, status: :not_found
  end
end
