class ChatsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_application
  before_action :set_chat, only: %i[ show update destroy ]

  # GET /applications/:application_token/chats
  def index
    @chats = Chat.where(application_id: @application.id).order(:number)

    if @chats.empty?
      render json: { message: 'No chats found' }, status: :ok
    else
      render json: { data: @chats, message: 'Chats found' }, status: :ok
    end
  end

  # GET /applications/:application_token/chats/:number
  def show
    render json: { data: @chat, message: 'Chat found' }, status: :ok
  end

  # PATCH/PUT /applications/:application_token/chats/:number
  def update
    if @chat.update(chat_params)
      render json: { data: @chat, message: "Chat updated" }, status: :ok
    else
      render json: @chat.errors, status: :unprocessable_entity
    end
  end

  # DELETE /applications/:application_token/chats/:number
  def destroy
    @chat.destroy!
    render json: { message: "Chat deleted" }, status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_application
      @application = Application.find_by(token: params[:application_token])

      if @application.nil?
        return render json: { message: "Application not found" }, status: :not_found
      end
    end

    def set_chat
      @chat = Chat.find_by(application_id: @application.id, number: params[:number])

      if @chat.nil?
        return render json: { message: "Chat not found" }, status: :not_found
      end
    end

    # Only allow a list of trusted parameters through.
    def chat_params
      params.require(:chat).permit()
    end
end
