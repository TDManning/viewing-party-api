class Api::V1::MoviesController < ApplicationController
  def index
    movies = if params[:query].present?
               Movie.query_movies(params[:query])
             elsif params[:filter] == 'top_rated'
               Movie.top_rated
             else
               Movie.top_rated # Default to top-rated movies if no params are provided
             end

    render json: MovieSerializer.new(movies).serializable_hash
  end
end


