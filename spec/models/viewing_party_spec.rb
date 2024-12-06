require "rails_helper"

RSpec.describe ViewingParty, type: :model do
  describe "relationships" do
    it { should belong_to(:host).class_name('User') }
    it { should have_many(:user_viewing_parties) }
    it { should have_many(:users).through(:user_viewing_parties) }
    it { should have_many(:invitees).through(:user_viewing_parties).source(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:end_time) }
    it { should validate_presence_of(:movie_id) }
    it { should validate_presence_of(:movie_title) }
  end

  describe "validations" do
    it "validates party duration meets movie runtime" do
      user = User.create!(
        name: "Test User",
        username: "test_user",
        password: "password",
        password_confirmation: "password"
      )

      viewing_party = ViewingParty.new(
        name: "Test Party",
        start_time: "2024-12-31 18:00:00",
        end_time: "2024-12-31 19:00:00",
        movie_id: 1,
        movie_title: "Test Movie",
        host: user 
      )

      viewing_party.movie_runtime = 120 

      expect(viewing_party).to_not be_valid
      expect(viewing_party.errors[:base]).to include("Party duration must be at least the movie runtime")
    end
  end

  describe "#add_invitees" do
    it "creates user_viewing_party records for invitees" do
      host = User.create!(name: "Host User", username: "host_user", password: "password")
      invitee1 = User.create!(name: "Invitee One", username: "invitee1", password: "password")
      invitee2 = User.create!(name: "Invitee Two", username: "invitee2", password: "password")

      viewing_party = ViewingParty.create!(
        name: "Test Party",
        start_time: "2024-12-31 18:00:00",
        end_time: "2024-12-31 21:00:00",
        movie_id: 1,
        movie_title: "Test Movie",
        host: host
      )

      expect {
        viewing_party.add_invitees([invitee1.id, invitee2.id])
      }.to change { UserViewingParty.count }.by(2)

      expect(viewing_party.invitees).to include(invitee1, invitee2)
    end
  end

  describe "#add_invitee!" do
  let!(:host) { User.create!(name: "Host User", username: "host_user", password: "password") }
  let!(:invitee) { User.create!(name: "Invitee User", username: "invitee_user", password: "password") }
  let!(:viewing_party) do
    ViewingParty.create!(
      name: "Test Party",
      start_time: "2024-12-31 18:00:00",
      end_time: "2024-12-31 21:00:00",
      movie_id: 1,
      movie_title: "Test Movie",
      host: host
    )
  end

  it "creates a UserViewingParty record for a valid invitee" do
    expect {
      viewing_party.add_invitee!(invitee.id)
    }.to change { UserViewingParty.count }.by(1)

    expect(viewing_party.invitees).to include(invitee)
  end

  it "raises an error for an invalid invitee" do
    expect {
      viewing_party.add_invitee!(999)
    }.to raise_error(ActiveRecord::RecordNotFound, "Invitee not found")
  end
end

context "custom validations" do
  let(:host) { User.create!(name: "Host User", username: "host_user", password: "password") }

  it "adds an error if end_time is before start_time" do
    viewing_party = ViewingParty.new(
      name: "Invalid Party",
      start_time: "2024-12-31 21:00:00",
      end_time: "2024-12-31 20:00:00", # Invalid: end_time before start_time
      movie_id: 1,
      movie_title: "Test Movie",
      host: host
    )

    expect(viewing_party).to_not be_valid
    expect(viewing_party.errors[:end_time]).to include("cannot be before or equal to the start time")
  end

  it "adds an error if end_time is equal to start_time" do
    viewing_party = ViewingParty.new(
      name: "Invalid Party",
      start_time: "2024-12-31 20:00:00",
      end_time: "2024-12-31 20:00:00", # Invalid: end_time equal to start_time
      movie_id: 1,
      movie_title: "Test Movie",
      host: host
    )

    expect(viewing_party).to_not be_valid
    expect(viewing_party.errors[:end_time]).to include("cannot be before or equal to the start time")
  end

  it "does not add an error if end_time is after start_time" do
    viewing_party = ViewingParty.new(
      name: "Valid Party",
      start_time: "2024-12-31 18:00:00",
      end_time: "2024-12-31 20:00:00", # Valid: end_time after start_time
      movie_id: 1,
      movie_title: "Test Movie",
      host: host
    )

    expect(viewing_party).to be_valid
  end
end
end
