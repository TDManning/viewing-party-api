require "rails_helper"

RSpec.describe "Users API", type: :request do
  describe "Create User Endpoint" do
    let(:user_params) do
      {
        name: "Me",
        username: "its_me",
        password: "QWERTY123",
        password_confirmation: "QWERTY123"
      }
    end

    context "request is valid" do
      it "returns 201 Created and provides expected fields" do
        post api_v1_users_path, params: user_params, as: :json

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data][:type]).to eq("user")
        expect(json[:data][:id]).to eq(User.last.id.to_s)
        expect(json[:data][:attributes][:name]).to eq(user_params[:name])
        expect(json[:data][:attributes][:username]).to eq(user_params[:username])
        expect(json[:data][:attributes]).to have_key(:api_key)
        expect(json[:data][:attributes]).to_not have_key(:password)
        expect(json[:data][:attributes]).to_not have_key(:password_confirmation)
      end
    end

    context "request is invalid" do
      it "returns an error for non-unique username" do
        User.create!(name: "me", username: "its_me", password: "abc123")

        post api_v1_users_path, params: user_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Username has already been taken")
        expect(json[:status]).to eq(400)
      end

      it "returns an error when password does not match password confirmation" do
        invalid_user_params = {
          name: "me",
          username: "its_me",
          password: "QWERTY123",
          password_confirmation: "QWERT123"
        }

        post api_v1_users_path, params: invalid_user_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Password confirmation doesn't match Password")
        expect(json[:status]).to eq(400)
      end

      it "returns an error for missing field" do
        user_params[:username] = ""

        post api_v1_users_path, params: user_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Username can't be blank")
        expect(json[:status]).to eq(400)
      end
    end
  end

  describe "Get All Users Endpoint" do
    it "retrieves all users but does not share any sensitive data" do
      User.create!(name: "Tom", username: "myspace_creator", password: "test123")
      User.create!(name: "Oprah", username: "oprah", password: "abcqwerty")
      User.create!(name: "Beyonce", username: "sasha_fierce", password: "blueivy")

      get api_v1_users_path

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data].count).to eq(3)
      expect(json[:data][0][:attributes]).to have_key(:name)
      expect(json[:data][0][:attributes]).to have_key(:username)
      expect(json[:data][0][:attributes]).to_not have_key(:password)
      expect(json[:data][0][:attributes]).to_not have_key(:password_digest)
      expect(json[:data][0][:attributes]).to_not have_key(:api_key)
    end
  end

  describe 'GET /api/v1/users/:id' do
    let!(:user) { User.create!(name: 'Leo DiCaprio', username: 'leo_real_verified', password: 'password123') }

    context 'when the user ID is valid' do
      let!(:hosted_party) do
        ViewingParty.create!(
          host_id: user.id,
          name: 'Titanic Watch Party',
          start_time: '2025-05-01 10:00:00',
          end_time: '2025-05-01 14:30:00',
          movie_id: 597,
          movie_title: 'Titanic'
        )
      end
      let!(:attended_party_1) do
        other_host = User.create!(name: 'Other Host', username: 'other_host', password: 'password123')
        ViewingParty.create!(
          host_id: other_host.id,
          name: 'LOTR Viewing Party',
          start_time: '2025-03-11 10:00:00',
          end_time: '2025-03-11 15:30:00',
          movie_id: 120,
          movie_title: 'The Lord of the Rings: The Fellowship of the Ring'
        )
      end
      let!(:attended_party_2) do
        other_host = User.create!(name: 'Another Host', username: 'another_host', password: 'password123')
        ViewingParty.create!(
          host_id: other_host.id,
          name: "Juliet's Bday Movie Bash!",
          start_time: '2025-02-01 10:00:00',
          end_time: '2025-02-01 14:30:00',
          movie_id: 278,
          movie_title: 'The Shawshank Redemption'
        )
      end

      before do
        UserViewingParty.create!(user: user, viewing_party: attended_party_1)
        UserViewingParty.create!(user: user, viewing_party: attended_party_2)
      end

      it 'returns the user profile with hosted and invited viewing parties' do
        get "/api/v1/users/#{user.id}"

        expect(response).to have_http_status(:success)
        json = JSON.parse(response.body, symbolize_names: true)
        data = json[:data]

        expect(data[:id]).to eq(user.id.to_s)
        expect(data[:type]).to eq('user_profile')
        expect(data[:attributes][:name]).to eq(user.name)
        expect(data[:attributes][:username]).to eq(user.username)

        hosted_parties = data[:attributes][:viewing_parties_hosted]
        expect(hosted_parties.size).to eq(1)
        expect(hosted_parties.first[:name]).to eq(hosted_party.name)

        invited_parties = data[:attributes][:viewing_parties_invited]
        expect(invited_parties.size).to eq(2)
        expect(invited_parties.map { |party| party[:name] }).to include('LOTR Viewing Party', "Juliet's Bday Movie Bash!")
      end

      it 'returns an empty array for hosted and invited viewing parties if none exist' do
        user_without_parties = User.create!(name: 'No Parties', username: 'no_parties_user', password: 'password123')

        get "/api/v1/users/#{user_without_parties.id}"

        expect(response).to have_http_status(:success)
        json = JSON.parse(response.body, symbolize_names: true)
        data = json[:data]

        expect(data[:attributes][:viewing_parties_hosted]).to eq([])
        expect(data[:attributes][:viewing_parties_invited]).to eq([])
      end
    end

    context 'when the user ID is invalid' do
      it 'returns a 404 error with an appropriate message' do
        get '/api/v1/users/999999'

        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:message]).to eq('Invalid User ID')
      end
    end
  end
end
