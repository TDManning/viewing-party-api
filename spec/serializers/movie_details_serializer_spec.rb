require 'rails_helper'

RSpec.describe MovieDetailsSerializer do
  describe '#serializable_hash' do
    let(:movie) do
      MovieDetails.new(
        id: 278,
        title: "The Shawshank Redemption",
        release_year: 1994,
        vote_average: 8.706,
        runtime: "2 hours, 22 minutes",
        genres: ["Drama", "Crime"],
        summary: "Imprisoned in the 1940s...",
        cast: [
          { character: "Andy Dufresne", actor: "Tim Robbins" },
          { character: "Ellis Boyd 'Red' Redding", actor: "Morgan Freeman" }
        ],
        total_reviews: 14,
        reviews: [
          { author: "elshaarawy", review: "very good movie 9.5/10" },
          { author: "John Chard", review: "Some birds aren't meant to be caged." }
        ]
      )
    end

    it 'returns the correct JSON structure' do
      serializer = MovieDetailsSerializer.new(movie)
      result = serializer.serializable_hash

      expect(result).to eq({
        data: {
          id: 278,
          type: 'movie',
          attributes: {
            title: "The Shawshank Redemption",
            release_year: 1994,
            vote_average: 8.706,
            runtime: "2 hours, 22 minutes",
            genres: ["Drama", "Crime"],
            summary: "Imprisoned in the 1940s...",
            cast: [
              { character: "Andy Dufresne", actor: "Tim Robbins" },
              { character: "Ellis Boyd 'Red' Redding", actor: "Morgan Freeman" }
            ],
            total_reviews: 14,
            reviews: [
              { author: "elshaarawy", review: "very good movie 9.5/10" },
              { author: "John Chard", review: "Some birds aren't meant to be caged." }
            ]
          }
        }
      })
    end

    it 'handles empty or missing attributes gracefully' do
      incomplete_movie = MovieDetails.new(
        id: nil,
        title: nil,
        release_year: nil,
        vote_average: nil,
        runtime: nil,
        genres: [],
        summary: nil,
        cast: [],
        total_reviews: 0,
        reviews: []
      )

      serializer = MovieDetailsSerializer.new(incomplete_movie)
      result = serializer.serializable_hash

      expect(result[:data][:attributes][:title]).to be_nil
      expect(result[:data][:attributes][:genres]).to eq([])
      expect(result[:data][:attributes][:cast]).to eq([])
      expect(result[:data][:attributes][:reviews]).to eq([])
    end
  end
end
