class Api::V1::MoviesController < ApplicationController
  def index
    movies = if params[:query].present?
               Movie.query_movies(params[:query])
             elsif params[:filter] == 'top_rated'
               Movie.top_rated
             else
               Movie.top_rated 
             end

    render json: MovieSerializer.new(movies).serializable_hash
  end

  def show
    movie = MovieDetailsFacade.fetch_movie_details(params[:id])
    
    if movie
      render json: MovieDetailsSerializer.new(movie).serializable_hash
    else
      render json: { error: 'Movie not found' }, status: :not_found
    end
  end
end


