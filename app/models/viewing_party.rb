class ViewingParty < ApplicationRecord
  attr_accessor :movie_runtime 

  belongs_to :host, class_name: 'User'
  has_many :user_viewing_parties
  has_many :users, through: :user_viewing_parties
  has_many :invitees, through: :user_viewing_parties, source: :user

  validates :name, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :movie_id, presence: true
  validates :movie_title, presence: true

  validate :end_time_after_start_time, if: -> { start_time.present? && end_time.present? }
  validate :party_duration_meets_movie_runtime, if: -> { start_time.present? && end_time.present? && movie_runtime.present? }

  def add_invitees(invitee_ids)
    invitee_ids.each do |invitee_id|
      invitee = User.find_by(id: invitee_id)
      next unless invitee
  
      UserViewingParty.create!(user: invitee, viewing_party: self)
    end
  end

  def add_invitee!(user_id)
    invitee = User.find_by(id: user_id)
    if invitee
      UserViewingParty.create!(user: invitee, viewing_party: self)
    else
      raise ActiveRecord::RecordNotFound, "Invitee not found"
    end
  end

  private

  def end_time_after_start_time
    if end_time <= start_time
      errors.add(:end_time, "cannot be before or equal to the start time")
    end
  end

  def party_duration_meets_movie_runtime
    duration_in_minutes = ((end_time - start_time) / 60).to_i
    if duration_in_minutes < movie_runtime.to_i
      errors.add(:base, "Party duration must be at least the movie runtime")
    end
  end
end
