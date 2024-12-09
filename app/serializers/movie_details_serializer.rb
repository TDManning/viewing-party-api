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
    return [] unless cast.is_a?(Array)

    cast.first(10).map do |member|
      {
        character: member[:character],
        actor: member[:name]
      }
    end
  end

  def format_reviews(reviews)
    return [] unless reviews.is_a?(Array)

    reviews.first(5).map do |review|
      {
        author: review[:author],
        review: review[:content]
      }
    end
  end
end
