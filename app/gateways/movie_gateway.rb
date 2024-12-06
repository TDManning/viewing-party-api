class MovieGateway
  BASE_URL = 'https://api.themoviedb.org/3/'

  def self.conn
    Faraday.new(url: BASE_URL)
  end

  def self.top_rated_movies
    response = conn.get('movie/top_rated', { api_key: Rails.application.credentials.dig(:tmdb, :api_key) })
    JSON.parse(response.body, symbolize_names: true)[:results]
  end

  # def self.search_movies(query)
  #   response = conn.get('search/movie', { query: query, api_key: Rails.application.credentials.dig(:tmdb, :api_key) })
  #   JSON.parse(response.body, symbolize_names: true)[:results]
  # end

  
  def self.search_movies(query)
    api_key = Rails.application.credentials.dig(:tmdb, :api_key)
    clean_query = query.strip # Remove newline and extra spaces
    response = conn.get('search/movie', { query: clean_query, api_key: api_key })
  
    Rails.logger.info("Request URL: #{response.env.url}")
    Rails.logger.info("Response status: #{response.status}")
    Rails.logger.info("Response body: #{response.body}")
  
    data = JSON.parse(response.body, symbolize_names: true) rescue nil
    return [] if data.nil? || !data[:results].is_a?(Array)
  
    data[:results]
  end
  
  
  
end
