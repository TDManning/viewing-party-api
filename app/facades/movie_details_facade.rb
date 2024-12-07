class MovieDetailsFacade
  def self.fetch_movie_details(movie_id)
    response = MovieGateway.fetch_movie_details(movie_id)
    return nil unless response

    MovieDetails.new(response)
  end
end
