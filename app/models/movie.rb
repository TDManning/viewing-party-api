class Movie
  BASE_URL = 'https://api.themoviedb.org/3/'

  attr_reader :id, :title, :vote_average

  def initialize(attributes)
    @id = attributes[:id]
    @title = attributes[:title]
    @vote_average = attributes[:vote_average]
  end

  def self.api_key
    Rails.env.production? ? ENV['TMDB_API_KEY'] : Rails.application.credentials.dig(:tmdb, :api_key)
  end

  def self.fetch(endpoint, params = {})
    response = Faraday.get("#{BASE_URL}#{endpoint}") do |req|
      req.params['api_key'] = api_key
      params.each do |key, value|
        req.params[key] = value
      end
    end

    puts "Response Status: #{response.status}"
    puts "Response Body: #{response.body}"
    puts "Response Headers: #{response.headers}"

    JSON.parse(response.body, symbolize_names: true)[:results]
  end

  def self.parse_response(movie_data, limit)
    limited_movies = movie_data.first(limit)

    movie_objects = limited_movies.map do |movie_attributes|
      new(movie_attributes)
    end
    movie_objects
  end

  def self.top_rated(limit = 20)
    movie_data = fetch('movie/top_rated')
    parse_response(movie_data, limit)
  end

  def self.query_movies(query, limit = 20)
    movie_data = fetch('search/movie', { query: query })
    parse_response(movie_data, limit)
  end
end
