require 'rails_helper'

RSpec.describe "Movies API", type: :request do
  describe "GET /api/v1/movies" do
    let(:test_api_key) { 'test_api_key' }

    before do
      allow(Movie).to receive(:api_key).and_return(test_api_key)
    end

    context "when fetching top-rated movies" do
      before do
        stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?api_key=#{test_api_key}")
          .to_return(
            status: 200,
            body: {
              results: [
                { id: 1, title: "The Shawshank Redemption", vote_average: 9.3 },
                { id: 2, title: "The Godfather", vote_average: 9.2 }
              ]
            }.to_json
          )
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

    context "when fetching movies by search query" do
      before do
        stub_request(:get, "https://api.themoviedb.org/3/search/movie?api_key=#{test_api_key}&query=Fight%20Club")
          .to_return(
            status: 200,
            body: {
              results: [
                { id: 550, title: "Fight Club", vote_average: 8.8 },
                { id: 551, title: "Fight Club: The Documentary", vote_average: 7.5 }
              ]
            }.to_json
          )
      end

      it "returns a list of movies that match the query" do
        get "/api/v1/movies", params: { query: "Fight Club" }

        expect(response).to have_http_status(:success)

        data = JSON.parse(response.body, symbolize_names: true)[:data]
        expect(data.size).to eq(2)

        expect(data.first).to include(
          id: "550",
          type: "movie",
          attributes: {
            title: "Fight Club",
            vote_average: 8.8
          }
        )

        expect(data.last).to include(
          id: "551",
          type: "movie",
          attributes: {
            title: "Fight Club: The Documentary",
            vote_average: 7.5
          }
        )
      end
    end
  end
end
