class MovieGateway
  BASE_URL = 'https://api.themoviedb.org/3/'

  def self.conn
    Faraday.new(url: BASE_URL)
  end

  def self.fetch(endpoint, params = {})
    response = conn.get(endpoint) do |req|
      req.params['api_key'] = Rails.application.credentials.dig(:tmdb, :api_key)
      params.each { |key, value| req.params[key] = value }
    end

    JSON.parse(response.body, symbolize_names: true)[:results]
  end
end
