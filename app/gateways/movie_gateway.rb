class MovieGateway
  BASE_URL = 'https://api.themoviedb.org/3/'

  def self.conn
    Faraday.new(url: BASE_URL)
  end

  def self.top_rated_movies
    response = conn.get('movie/top_rated', { api_key: Rails.application.credentials.dig(:tmdb, :api_key) })
    JSON.parse(response.body, symbolize_names: true)[:results]
  end

  def self.search_movies(query)
    response = conn.get('search/movie', { query: query, api_key: Rails.application.credentials.dig(:tmdb, :api_key) })
    JSON.parse(response.body, symbolize_names: true)[:results]
  end
  end
  
  
  

