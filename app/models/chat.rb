class Chat < ApplicationRecord
  belongs_to :application
  has_many :messages, dependent: :destroy

  scope :last_number_by_application, -> (application_id) { where(application_id: application_id).order(number: :desc).limit(1).pluck(:number).first.to_i rescue 0 }

  def self.custom_create!(params)
    ActiveRecord::Base.transaction do
      last_number = Chat.last_number_by_application(params[:application_id])
      chat = Chat.new(params.merge(number: last_number + 1))
      chat.save!
      return chat
    end
  end

  def as_json(options = {})
    super(options.merge(except: :id))
  end
end
