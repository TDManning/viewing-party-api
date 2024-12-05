require 'rails_helper'

RSpec.describe Movie, type: :model do
  let(:test_api_key) { 'test_api_key' }

  before do
    allow(Movie).to receive(:api_key).and_return(test_api_key)
  end

  describe ".top_rated" do
    it "returns an array of movie objects with correct attributes" do
      response_body = {
        results: [
          { id: 1, title: "The Shawshank Redemption", vote_average: 9.3 },
          { id: 2, title: "The Godfather", vote_average: 9.2 }
        ]
      }.to_json

      stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?api_key=#{test_api_key}")
        .to_return(status: 200, body: response_body)

      movies = Movie.top_rated

      expect(movies.size).to eq(2)
      expect(movies.first).to have_attributes(
        id: 1,
        title: "The Shawshank Redemption",
        vote_average: 9.3
      )
    end

    it "returns up to 20 top-rated movies" do
      stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?api_key=#{test_api_key}")
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

  describe ".query_movies" do
    it "returns an array of movie objects that match the query" do
      response_body = {
        results: [
          { id: 550, title: "Fight Club", vote_average: 8.8 },
          { id: 554, title: "The Fight Club Documentary", vote_average: 7.5 }
        ]
      }.to_json

      stub_request(:get, "https://api.themoviedb.org/3/search/movie?api_key=#{test_api_key}&query=Fight%20Club")
        .to_return(status: 200, body: response_body)

      movies = Movie.query_movies("Fight Club")

      expect(movies.size).to eq(2)
      expect(movies.first).to have_attributes(
        id: 550,
        title: "Fight Club",
        vote_average: 8.8
      )
    end

    it "returns an empty array if no results are found" do
      response_body = { results: [] }.to_json

      stub_request(:get, "https://api.themoviedb.org/3/search/movie?api_key=#{test_api_key}&query=Nonexistent%20Movie")
        .to_return(status: 200, body: response_body)

      movies = Movie.query_movies("Nonexistent Movie")

      expect(movies).to be_empty
    end
  end

  describe '.api_key' do
    context 'when in the test environment' do
      it 'returns the test API key' do
        allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new("test"))

        expect(Movie.api_key).to eq("test_api_key")
      end
    end

    context 'when in non-test environments' do
      it 'returns the API key from Rails credentials' do
        allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new("development"))
        allow(Rails.application.credentials).to receive(:dig).with(:tmdb, :api_key).and_return("development_api_key")

        expect(Movie.api_key).to eq("development_api_key")
      end
    end
  end
end
