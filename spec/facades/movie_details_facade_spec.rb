require 'rails_helper'

RSpec.describe MovieDetailsFacade do
  describe '.fetch_movie_details' do
    it 'returns a MovieDetails object for a valid ID' do
      movie_id = 550
      response = {
        id: 550,
        title: 'Fight Club',
        release_date: '1999-10-15',
        vote_average: 8.4,
        runtime: 139,
        genres: [{ name: 'Drama' }],
        overview: 'An insomniac office worker...',
        credits: {
          cast: [{ character: 'Narrator', name: 'Edward Norton' }]
        },
        reviews: {
          total_results: 12,
          results: [{ author: 'Reviewer 1', content: 'Amazing movie!' }]
        }
      }

      allow(MovieGateway).to receive(:fetch_movie_details).with(movie_id).and_return(response)

      movie = MovieDetailsFacade.fetch_movie_details(movie_id)

      expect(movie).to be_a(MovieDetails)
      expect(movie.id).to eq(550)
      expect(movie.title).to eq('Fight Club')
    end

    it 'returns nil for an invalid ID' do
      invalid_id = 999999
      allow(MovieGateway).to receive(:fetch_movie_details).with(invalid_id).and_return(nil)

      movie = MovieDetailsFacade.fetch_movie_details(invalid_id)

      expect(movie).to be_nil
    end
  end
end
