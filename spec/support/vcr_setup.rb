require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr_cassettes'
  config.hook_into :faraday
  config.allow_http_connections_when_no_cassette = false
  config.configure_rspec_metadata!
  config.filter_sensitive_data('<TMDB_API_KEY>') { Rails.application.credentials.dig(:tmdb, :api_key) }
end
