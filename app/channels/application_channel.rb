class ApplicationChannel < ApplicationCable::Channel
  def subscribed
    reject_unless_chat_exists
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    application = Application.find_by(token: params[:application_token])

    CreateChatJob.perform_later(application.token)
  end


  private

  def reject_unless_chat_exists
    application = Application.find_by(token: params[:application_token])
    if application
      stream_from "application_#{params[:application_token]}"
    else
      reject
    end
  end
end
