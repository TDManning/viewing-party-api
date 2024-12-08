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

  describe ".fetch_movie_details" do
    it "returns movie details when a valid ID is provided" do
      VCR.use_cassette("movies_details_valid_id_gateway") do
        movie_id = 550
        details = MovieGateway.fetch_movie_details(movie_id)

        expect(details).to be_a(Hash)
        expect(details[:id]).to eq(550)
        expect(details[:title]).to eq("Fight Club")
      end
    end

    it "returns nil when the movie ID is invalid" do
      VCR.use_cassette("movies_details_invalid_id_gateway") do
        movie_id = 9999991234
        details = MovieGateway.fetch_movie_details(movie_id)
        expect(details).to be_nil
      end
    end

  describe ".conn" do
    it "initializes a Faraday connection with the correct base URL" do
      connection = MovieGateway.conn
      expect(connection.url_prefix.to_s).to eq("https://api.themoviedb.org/3/")
    end
  end

  describe ".api_key" do
    it "retrieves the API key from credentials" do
      api_key = MovieGateway.send(:api_key)
      expect(api_key).to eq(Rails.application.credentials.dig(:tmdb, :api_key))
    end
  end

  describe ".parse_response" do  
    it "parses and returns JSON for a successful response" do
      response = instance_double(Faraday::Response, success?: true, body: '{"id": 123}')
      parsed = MovieGateway.send(:parse_response, response)
  
      expect(parsed).to eq({ id: 123 })
    end
  end
end
end
