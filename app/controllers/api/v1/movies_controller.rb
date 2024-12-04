class Api::V1::MoviesController < ApplicationController
  def index
    if params[:query].present?
      movies = Movie.search(params[:query])
    elsif params[:filter] == 'top_rated'
      movies = Movie.top_rated
    else
      movies = []
    end

    render json: MovieSerializer.new(movies).serializable_hash
  end
end


