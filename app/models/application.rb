class Application < ApplicationRecord
  has_many :chats, dependent: :destroy

  def as_json(options = {})
    super(options.merge(except: :id))
  end
end
