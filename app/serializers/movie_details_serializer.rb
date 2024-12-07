class MovieDetailsSerializer
  def initialize(movie)
    @movie = movie
  end

  def serializable_hash
    {
      data: {
        id: @movie.id,
        type: 'movie',
        attributes: {
          title: @movie.title,
          release_year: @movie.release_year,
          vote_average: @movie.vote_average,
          runtime: @movie.runtime,
          genres: @movie.genres,
          summary: @movie.summary,
          cast: format_cast(@movie.cast),
          total_reviews: @movie.total_reviews,
          reviews: format_reviews(@movie.reviews)
        }
      }
    }
  end

  private

  def format_cast(cast)
    cast.map do |member|
      {
        character: member[:character],
        actor: member[:actor]
      }
    end
  end

  def format_reviews(reviews)
    reviews.map do |review|
      {
        author: review[:author],
        review: review[:review]
      }
    end
  end
end
