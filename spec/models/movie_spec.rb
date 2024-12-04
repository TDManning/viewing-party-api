require 'rails_helper'

RSpec.describe Movie, type: :model do
  describe ".top_rated" do
    it "returns an array of movie objects with correct attributes" do
      response_body = {
        results: [
          { id: 1, title: "The Shawshank Redemption", vote_average: 9.3 },
          { id: 2, title: "The Godfather", vote_average: 9.2 }
        ]
      }.to_json

      stub_request(:get, %r{https://api.themoviedb.org/3/movie/top_rated})
        .to_return(status: 200, body: response_body)

      movies = Movie.top_rated

      expect(movies.size).to eq(2)
      expect(movies.first).to have_attributes(
        id: 1,
        title: "The Shawshank Redemption",
        vote_average: 9.3
      )
    end
  end

  describe ".top_rated" do
    it "returns up to 20 top-rated movies" do
      stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?api_key=065266c07dd539b7a9d040e97052561c")
        .to_return(
          status: 200,
          body: {
            results: Array.new(30) { |i| { id: i, title: "Movie #{i}", vote_average: 8.5 } }
          }.to_json
        )
      movies = Movie.top_rated
      expect(movies.length).to eq(20)
    end
  end
end
