class CreateChatJob < ApplicationJob
  queue_as :default
  @@application = nil
  @@chat = nil

  after_perform do |job|
    # I want to access the @chat variable here
    ActionCable.server.broadcast("application_#{@@application.token}", { message: "A new chat has been created for application #{@@application.token}", chat_number: @@chat.number})
  end

  def perform(application_token)
    @@application = Application.find_by(token: application_token)
    @@chat = Chat.custom_create!(application_id: @@application.id)

    CalculateTotalsCronJob.perform_async({"type"=> "chats", "application_id"=> @@application.id})
  end
end
