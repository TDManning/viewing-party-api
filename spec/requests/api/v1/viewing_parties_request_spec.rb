require "rails_helper"

RSpec.describe "Viewing Parties API", type: :request do
  describe "Create Viewing Parties Endpoint" do
    let!(:host) { User.create!(name: "Host User", username: "host_user", password: "password") }
    let!(:invitee1) { User.create!(name: "Invitee One", username: "invitee1", password: "password") }
    let!(:invitee2) { User.create!(name: "Invitee Two", username: "invitee2", password: "password") }
    let(:viewing_party_params) do
      {
        name: "Test Party",
        start_time: "2024-12-31 18:00:00",
        end_time: "2024-12-31 21:00:00",
        movie_id: 1,
        movie_title: "Test Movie",
        host_id: host.id,
        invitees: [invitee1.id, invitee2.id]
      }
    end

    context "when the request is valid" do
      it "creates a new viewing party and returns the expected fields" do
        post api_v1_viewing_parties_path, params: viewing_party_params, as: :json

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:data][:type]).to eq("viewing_party")
        expect(json[:data][:attributes][:name]).to eq(viewing_party_params[:name])
        expect(json[:data][:attributes][:start_time]).to eq(viewing_party_params[:start_time].to_datetime.iso8601)
        expect(json[:data][:attributes][:end_time]).to eq(viewing_party_params[:end_time].to_datetime.iso8601)
      end
    end

    context "when the request is invalid" do
      it "returns an error when the host does not exist" do
        invalid_params = viewing_party_params.merge(host_id: nil)

        post api_v1_viewing_parties_path, params: invalid_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Host must exist")
      end

      it "returns an error when required fields are missing" do
        invalid_params = viewing_party_params.except(:name)

        post api_v1_viewing_parties_path, params: invalid_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Name can't be blank")
      end

      it "returns an error when party duration is less than movie runtime" do
        invalid_params = viewing_party_params.merge(
          start_time: "2024-12-31 18:00:00",
          end_time: "2024-12-31 18:30:00",
          movie_runtime: 120 
        )
      
        post api_v1_viewing_parties_path, params: invalid_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)
      
        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Party duration must be at least the movie runtime")
      end
      

      it "returns an error when end time is before start time" do
        invalid_params = viewing_party_params.merge(start_time: "2024-12-31 21:00:00", end_time: "2024-12-31 18:00:00")

        post api_v1_viewing_parties_path, params: invalid_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("End time cannot be before or equal to the start time")
      end

      it "creates a viewing party with only valid invitees" do
        invalid_params = viewing_party_params.merge(invitees: [invitee1.id, 999])

        post api_v1_viewing_parties_path, params: invalid_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:created)
        expect(json[:data][:attributes][:invitees].count).to eq(1)
        expect(json[:data][:attributes][:invitees][0][:id]).to eq(invitee1.id)
      end
    end
  end
end


