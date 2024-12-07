require 'rails_helper'

RSpec.describe MovieDetails, type: :poro do
  let(:movie_data) do
    {
      id: 550,
      title: 'Fight Club',
      release_date: '1999-10-15',
      vote_average: 8.4,
      runtime: 139,
      genres: [{ name: 'Drama' }],
      overview: 'An insomniac office worker...',
      credits: {
        cast: [
          { character: 'Narrator', name: 'Edward Norton' },
          { character: 'Tyler Durden', name: 'Brad Pitt' }
        ]
      },
      reviews: {
        total_results: 12,
        results: [
          { author: 'Reviewer 1', content: 'Amazing movie!' },
          { author: 'Reviewer 2', content: 'Incredible.' }
        ]
      }
    }
  end

  it 'initializes with detailed movie data' do
    movie = MovieDetails.new(movie_data)

    expect(movie.id).to eq(550)
    expect(movie.title).to eq('Fight Club')
    expect(movie.release_year).to eq(1999)
    expect(movie.vote_average).to eq(8.4)
    expect(movie.runtime).to eq('2 hours, 19 minutes')
    expect(movie.genres).to eq(['Drama'])
    expect(movie.summary).to eq('An insomniac office worker...')
    expect(movie.cast).to include({ character: 'Narrator', actor: 'Edward Norton' })
    expect(movie.total_reviews).to eq(12)
    expect(movie.reviews.first).to eq({ author: 'Reviewer 1', review: 'Amazing movie!' })
  end
end
