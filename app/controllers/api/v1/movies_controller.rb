class Api::V1::MoviesController < ApplicationController
  def index
    if params[:query].present?
      movies = Movie.query_movies(params[:query])
    elsif params[:filter] == 'top_rated'
      movies = Movie.top_rated
    else
      movies = Movie.top_rated # Default to top-rated movies if no params are provided
    end

    render json: MovieSerializer.new(movies).serializable_hash
  end
end
