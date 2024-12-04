require 'rails_helper'

RSpec.describe "Movies API", type: :request do
  describe "GET /api/v1/movies" do
    context "when fetching top-rated movies" do
      before do
        response_body = {
          results: [
            { id: 1, title: "The Shawshank Redemption", vote_average: 9.3 },
            { id: 2, title: "The Godfather", vote_average: 9.2 }
          ]
        }.to_json

        stub_request(:get, %r{https://api.themoviedb.org/3/movie/top_rated})
          .to_return(status: 200, body: response_body)
      end

      it "returns a list of top-rated movies" do
        get "/api/v1/movies?filter=top_rated"

        expect(response).to have_http_status(:success)

        data = JSON.parse(response.body, symbolize_names: true)[:data]
        expect(data.size).to eq(2)

        expect(data.first).to include(
          id: "1",
          type: "movie",
          attributes: {
            title: "The Shawshank Redemption",
            vote_average: 9.3
          }
        )
      end
    end
  end
end
