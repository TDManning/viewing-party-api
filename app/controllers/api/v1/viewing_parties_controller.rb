class Api::V1::ViewingPartiesController < ApplicationController
 def create

  viewing_party = ViewingParty.new(viewing_party_params.except(:invitees))
  viewing_party.host_id= viewing_party_params[:host_id]

  if viewing_party.save
    viewing_party.add_invitees(viewing_party_params[:invitees])
    render json: ViewingPartySerializer.new(viewing_party), status: :created
  else
    render json: ErrorSerializer.format_error(ErrorMessage.new(viewing_party.errors.full_messages.to_sentence, 400)), status: :bad_request
  end
 end

 private

 def viewing_party_params
  params.permit(:name, :start_time, :end_time, :movie_id, :movie_title, :host_id, invitees: [])
 end
end


