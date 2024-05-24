class CreateMessageJob < ApplicationJob
  queue_as :default
  @@application = nil
  @@chat = nil
  @@user = nil
  @@message = nil

  after_perform do |job|
    ActionCable.server.broadcast("application_#{@@application.token}_chat_#{@@chat.number}", {message: @@message.as_json, user: @@user.as_json(only: [:username])})
  end

  def perform(application_token, chat_number, username, body)
    @@application = Application.find_by(token: application_token)
    @@chat = Chat.find_by(application_id: @@application.id,number: chat_number)
    @@user = User.find_by(username: username)
    begin
      @@message = Message.custom_create!(body: body, user_id: @@user.id, chat_id: @@chat.id)
      CalculateTotalsCronJob.perform_async({"type"=> "messages", "application_id"=> @@application.id, "number"=> @@chat.number})
    rescue Faraday::ConnectionFailed => e
      if e.message.include?(":9200")
        puts "Elasticsearch is down"
        return
      end
    end
  end
end
