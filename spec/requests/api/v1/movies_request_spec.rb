require "rails_helper"

RSpec.describe "Movies Endpoint" do
  describe "happy path" do
    it "retrieves the top-rated movies" do
      VCR.use_cassette("movies_top_rated") do
        get "/api/v1/movies?filter=top_rated"
      end

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data]).to be_an(Array)
      expect(json[:data].size).to be <= 20 
      json[:data].each do |movie|
        expect(movie).to have_key(:id)
        expect(movie[:type]).to eq("movie")
        expect(movie[:attributes]).to have_key(:title)
        expect(movie[:attributes]).to have_key(:vote_average)
      end
    end

    it "retrieves movies by a search query" do
      VCR.use_cassette("movies_search_inception") do
        get "/api/v1/movies?query=Inception"
      end

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data]).to be_an(Array)
      expect(json[:data].size).to be <= 20 
      json[:data].each do |movie|
        expect(movie).to have_key(:id)
        expect(movie[:type]).to eq("movie")
        expect(movie[:attributes]).to have_key(:title)
        expect(movie[:attributes][:title]).to include("Inception")
        expect(movie[:attributes]).to have_key(:vote_average)
      end
    end
  end

    it "defaults to top-rated movies when no query or filter is provided" do
      VCR.use_cassette("movies_top_rated_default_request") do
        get "/api/v1/movies"
      end

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data]).to be_an(Array)
      expect(json[:data].size).to be <= 20
      expect(json[:data].first[:type]).to eq("movie")
    end

    describe 'GET /api/v1/movies/:id' do
      it 'returns movie details for a valid ID', :vcr do
        get '/api/v1/movies/278'
  
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body, symbolize_names: true)
  
        expect(json[:data][:attributes][:title]).to eq('The Shawshank Redemption')
      end
  
      it 'returns an error for an invalid ID', :vcr do
        get '/api/v1/movies/999999'
  
        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body, symbolize_names: true)
  
        expect(json[:error]).to eq('Movie not found')
      end
    end
    describe 'GET /api/v1/movies/:id' do
      it 'returns serialized movie details for a valid ID', :vcr do
        VCR.use_cassette('movies/valid_movie_details') do
          get '/api/v1/movies/278'
  
          expect(response).to have_http_status(:ok)
          json = JSON.parse(response.body, symbolize_names: true)
  
          expect(json[:data][:id]).to eq(278)
          expect(json[:data][:attributes][:title]).to eq("The Shawshank Redemption")
        end
      end
  
      it 'returns an error for an invalid ID', :vcr do
        VCR.use_cassette('movies/invalid_movie_details') do
          get '/api/v1/movies/999999'
  
          expect(response).to have_http_status(:not_found)
          json = JSON.parse(response.body, symbolize_names: true)
  
          expect(json[:error]).to eq('Movie not found')
        end
      end
    end
  end

