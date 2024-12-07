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

  describe '.fetch_movie_details' do
    it 'returns movie details when a valid ID is provided', :vcr do
      movie_id = 550
      details = MovieGateway.fetch_movie_details(movie_id)

      expect(details).to be_a(Hash)
      expect(details[:id]).to eq(550)
      expect(details[:title]).to eq('Fight Club')
    end

    it 'returns nil for an invalid ID', :vcr do
      invalid_id = 999999
      details = MovieGateway.fetch_movie_details(invalid_id)

      expect(details).to be_nil
    end
  end
end
