class User < ApplicationRecord
  has_many :user_viewing_parties
  has_many :viewing_parties, through: :user_viewing_parties
  has_many :viewing_parties_hosted, class_name: 'ViewingParty', foreign_key: 'host_id'
  has_many :viewing_parties_attended, through: :user_viewing_parties, source: :viewing_party

  validates :name, presence: true
  validates :username, presence: true, uniqueness: true
  validates :password, presence: { require: true }
  has_secure_password
  has_secure_token :api_key
end