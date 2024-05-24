class CalculateTotalsCronJob
  include Sidekiq::Job
  queue_as :default

  def perform(args = {})
    if args["type"] == "chats" and args["application_id"] != nil
      application = Application.find(args["application_id"])
      application.update!(chats_count: application.chats.count)
    elsif args["type"] == "messages" and args["application_id"] != nil and args["number"] != nil
      chat = Chat.find_by(application_id: args["application_id"], number: args["number"])
      chat.update!(messages_count: chat.messages.count)
    elsif args.blank?
      calculate_total_chats
      calculate_total_messages
    end
  end

  private

  def calculate_total_chats
    Application.find_each do |application|
      application.update!(chats_count: application.chats.count)
    end
  end

  def calculate_total_messages
    Chat.find_each do |chat|
      chat.update!(messages_count: chat.messages.count)
    end
  end
end
