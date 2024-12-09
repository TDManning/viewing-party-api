class MovieDetails
  attr_reader :id, :title, :release_year, :vote_average, :runtime, :genres, :summary, :cast, :total_reviews, :reviews

  def initialize(data)
    @id = data[:id]
    @title = data[:title]
    @release_year = data[:release_date]&.to_date&.year
    @vote_average = data[:vote_average]
    @runtime = format_runtime(data[:runtime])
    @genres = data[:genres].map { |genre| genre[:name] }
    @summary = data[:overview]
    @cast = data[:credits][:cast] # Store raw cast data
    @total_reviews = data[:reviews][:total_results]
    @reviews = data[:reviews][:results] # Store raw reviews data
  end

  private

  def format_runtime(minutes)
    return minutes if minutes.is_a?(String)

    hours = minutes / 60
    remaining_minutes = minutes % 60
    "#{hours} hours, #{remaining_minutes} minutes"
  end
end
