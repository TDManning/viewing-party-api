class ViewingParty < ApplicationRecord
  belongs_to :host, class_name: 'User'
  has_many :user_viewing_parties
  has_many :users, through: :user_viewing_parties
  has_many :invitees, through: :user_viewing_parties, source: :user

  validates :name, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :movie_id, presence: true
  validates :movie_title, presence: true

  def add_invitees(invitee_ids)
    invitee_ids.each do |invitee_id|
      UserViewingParty.create!(user_id: invitee_id, viewing_party: self)
    end
  end
end
