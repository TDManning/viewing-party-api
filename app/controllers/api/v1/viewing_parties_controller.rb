class Api::V1::ViewingPartiesController < ApplicationController
  def create
    viewing_party = ViewingParty.new(viewing_party_params.except(:invitees, :movie_runtime))
    viewing_party.host_id = viewing_party_params[:host_id]
    viewing_party.movie_runtime = params[:movie_runtime] 

    if viewing_party.save
      viewing_party.add_invitees(viewing_party_params[:invitees])
      render json: ViewingPartySerializer.new(viewing_party), status: :created
    else
      render json: ErrorSerializer.format_error(ErrorMessage.new(viewing_party.errors.full_messages.to_sentence, 400)), status: :bad_request
    end
  end

  private

  def viewing_party_params
    params.permit(:name, :start_time, :end_time, :movie_id, :movie_title, :host_id, :movie_runtime, invitees: [])
  end
end
