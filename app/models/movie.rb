class Movie
  BASE_URL = 'https://api.themoviedb.org/3'

  attr_reader :id, :title, :vote_average

  def initialize(attributes)
    @id = attributes[:id]
    @title = attributes[:title]
    @vote_average = attributes[:vote_average]
  end

  def self.api_key
    Rails.env.production? ? ENV['TMDB_API_KEY'] : Rails.application.credentials.dig(:tmdb, :api_key)
  end

  def self.top_rated(limit = 20)
    response = Faraday.get("#{BASE_URL}/movie/top_rated") do |req|
      req.params['api_key'] = api_key
    end

    movie_data = JSON.parse(response.body, symbolize_names: true)[:results]
    movie_data.first(limit).map { |movie_attributes| new(movie_attributes) }
  end
end
