class Movie
  attr_reader :id, :title, :vote_average

  def initialize(attributes)
    @id = attributes[:id]
    @title = attributes[:title]
    @vote_average = attributes[:vote_average]
  end

  def self.top_rated(limit = 20)
    movie_data = MovieGateway.top_rated_movies
    Rails.logger.info("Received movie data: #{movie_data.inspect}")

    parse_response(movie_data, limit)
  end

  def self.query_movies(query, limit = 20)
    movie_data = MovieGateway.search_movies(query)
    parse_response(movie_data, limit)
  end

  private

  # def self.parse_response(movie_data, limit)
  #   movie_data.first(limit).map { |attributes| new(attributes) }
  # end

  def self.parse_response(movie_data, limit)
    return [] unless movie_data.is_a?(Array) && movie_data.any?

    movie_data.first(limit).map { |attributes| new(attributes) }
  end
end

