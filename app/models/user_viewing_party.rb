class UserViewingParty < ApplicationRecord
  belongs_to :user
  belongs_to :viewing_party

  validates :user_id, presence: true
  validates :viewing_party_id, presence: true
  validates :user_id, uniqueness: { scope: :viewing_party_id, message: "is already part of this viewing party" }
end