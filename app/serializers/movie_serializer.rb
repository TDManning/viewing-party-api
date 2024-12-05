class MovieSerializer
  def initialize(movies)
    @movies = movies
  end

  def serializable_hash
    {
      data: @movies.map do |movie|
        {
          id: movie.id,
          type: 'movie',
          attributes: {
            title: movie.title,
            vote_average: movie.vote_average
          }
        }
      end
    }
  end
end
