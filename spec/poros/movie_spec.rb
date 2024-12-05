require "rails_helper"

RSpec.describe Movie do
  describe "instance methods" do
    it "can extract data from a JSON hash and populate attributes" do
      sample_input = {
        id: 1,
        title: "Inception",
        vote_average: 8.8
      }

      result_movie = Movie.new(sample_input)

      expect(result_movie.id).to eq(1)
      expect(result_movie.title).to eq("Inception")
      expect(result_movie.vote_average).to eq(8.8)
    end
  end

  describe "class methods" do
    it "returns top-rated movies" do
      VCR.use_cassette("movies_top_rated") do
        result_movies = Movie.top_rated

        expect(result_movies).to be_an(Array)
        expect(result_movies.first).to be_a(Movie)
        expect(result_movies.first.title).not_to be_nil
        expect(result_movies.first.vote_average).to be_a(Float)
      end
    end

    it "returns queried movies" do
      VCR.use_cassette("movies_search_inception") do
        result_movies = Movie.query_movies("Inception")

        expect(result_movies).to be_an(Array)
        expect(result_movies.first).to be_a(Movie)
        expect(result_movies.first.title).to include("Inception")
        expect(result_movies.first.vote_average).to be_a(Float)
      end
    end
  end
end
