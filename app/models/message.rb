class Message < ApplicationRecord
  include Searchable

  validates :body, presence: true
  belongs_to :user
  belongs_to :chat

  scope :last_number_by_chat, -> (chat_id) { where(chat_id: chat_id).order(number: :desc).limit(1).pluck(:number).first.to_i rescue 0 }

  def self.custom_create!(params)
    ActiveRecord::Base.transaction do
      chat = Chat.find(params[:chat_id])
      last_number = Message.last_number_by_chat(chat.id)

      message = Message.new(params.merge(number: last_number + 1))
      message.save!
      return message
    end
  end

  def as_json(options = {})
    super(options.merge(except: :id))
  end
end
