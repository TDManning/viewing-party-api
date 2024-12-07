class MovieGateway
  BASE_URL = 'https://api.themoviedb.org/3/'

  def self.conn
    Faraday.new(url: BASE_URL)
  end

  def self.top_rated_movies
    response = conn.get('movie/top_rated', { api_key: api_key })
    parse_response(response)[:results]
  end

  def self.search_movies(query)
    response = conn.get('search/movie', { query: query, api_key: api_key })
    parse_response(response)[:results]
  end

  def self.fetch_movie_details(movie_id)
    response = conn.get("movie/#{movie_id}", {
      api_key: api_key,
      append_to_response: 'credits,reviews'
    })
    parse_response(response)
  end

  private

  def self.api_key
    Rails.application.credentials.dig(:tmdb, :api_key)
  end

  def self.parse_response(response)
    if response.success?
      JSON.parse(response.body, symbolize_names: true)
    else
      Rails.logger.error("Error fetching data from TMDb API: #{response.status} - #{response.body}")
      nil
    end
  end
end