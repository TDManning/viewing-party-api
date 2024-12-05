require "rails_helper"

RSpec.describe MovieGateway do
  describe "top rated movies" do
    it "retrieves a list of top-rated movies from TMDB API" do
      VCR.use_cassette("movies_top_rated_gateway") do
        response_array = MovieGateway.top_rated_movies

        expect(response_array).to be_an Array
        expect(response_array.size).to be > 0
        first_movie = response_array[0]

        expect(first_movie).to have_key(:id)
        expect(first_movie).to have_key(:title)
        expect(first_movie).to have_key(:vote_average)
      end
    end
  end

  describe "search movies" do
    it "retrieves a list of movies matching the query from TMDB API" do
      VCR.use_cassette("movies_search_inception_gateway") do
        response_array = MovieGateway.search_movies("Inception")

        expect(response_array).to be_an Array
        expect(response_array.size).to be > 0
        first_movie = response_array[0]

        expect(first_movie).to have_key(:id)
        expect(first_movie).to have_key(:title)
        expect(first_movie[:title]).to include("Inception")
        expect(first_movie).to have_key(:vote_average)
      end
    end
  end
end
