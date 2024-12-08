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
    @cast = format_cast(data[:credits][:cast])
    @total_reviews = data[:reviews][:total_results]
    @reviews = format_reviews(data[:reviews][:results])
  end

  private

  def format_runtime(minutes)
    return minutes if minutes.is_a?(String) 
    
    hours = minutes / 60
    remaining_minutes = minutes % 60
    "#{hours} hours, #{remaining_minutes} minutes"
  end
  

  def format_cast(cast)
    return [] unless cast.is_a?(Array)

    cast.first(10).map do |member|
      { character: member[:character], actor: member[:name] }
    end
  end

  def format_reviews(reviews)
    return [] unless reviews.is_a?(Array)

    reviews.first(5).map do |review|
      { author: review[:author], review: review[:content] }
    end
  end
end
