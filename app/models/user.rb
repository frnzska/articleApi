class User < ApplicationRecord
  validates :login, presence: true, uniqueness: true
  has_one :access_token, dependent: :destroy
end
