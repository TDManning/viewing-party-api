class ViewingParty < ApplicationRecord
  # belongs_to :host

  has_many :user_viewing_parties
  has_many :invitees, through: :user_viewing_parties

  validates :name, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :movie_id, presence: true
  validates :movie_title, presence: true
end