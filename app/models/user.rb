class User < ApplicationRecord
  has_many :user_viewing_parties
  has_many :viewing_parties, through: :user_viewing_parties
  has_many :hosted_parties, class_name: 'ViewingParty', foreign_key: 'host_id'
  has_many :invitations
  has_many :invited_parties, through: :invitations, source: :viewing_party

  validates :name, presence: true
  validates :username, presence: true, uniqueness: true
  validates :password, presence: { require: true }
  has_secure_password
  has_secure_token :api_key
end