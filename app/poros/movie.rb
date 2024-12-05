class Movie
  attr_reader :id, :title, :vote_average

  def initialize(attributes)
    @id = attributes[:id]
    @title = attributes[:title]
    @vote_average = attributes[:vote_average]
  end

  def self.top_rated(limit = 20)
    movie_data = MovieGateway.fetch('movie/top_rated')
    parse_response(movie_data, limit)
  end

  def self.query_movies(query, limit = 20)
    movie_data = MovieGateway.fetch('search/movie', { query: query })
    parse_response(movie_data, limit)
  end

  def self.parse_response(movie_data, limit)
    movie_data.first(limit).map { |attributes| new(attributes) }
  end
end
