class UserViewingParty < ApplicationRecord
  belongs_to :user
  belongs_to :viewing_party_id

  validates :user_id, presence: true
  validates :viewing_party_id, presence: true
end