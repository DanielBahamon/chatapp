class User < ApplicationRecord
  devise :database_authenticatable, :jwt_authenticatable, :registerable, :validatable,
          jwt_revocation_strategy: JwtDenylist

  has_many :messages
  validates_presence_of :username, :email, :password
  def as_json(options = {})
    super(options.merge(except: :id))
  end
end
