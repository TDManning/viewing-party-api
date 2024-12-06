module Api
  module V1
    module ViewingParties
      class InviteesController < ApplicationController
        def create
          viewing_party = ViewingParty.find_by(id: params[:viewing_party_id])

          unless viewing_party
            render json: ErrorSerializer.format_error(ErrorMessage.new("Viewing Party not found", 404)), status: :not_found and return
          end

          viewing_party.add_invitee!(invitee_params[:invitees_user_id])

          render json: ViewingPartySerializer.new(viewing_party), status: :ok
        rescue ActiveRecord::RecordNotFound => e
          render json: ErrorSerializer.format_error(ErrorMessage.new(e.message, 404)), status: :not_found
        rescue ActiveRecord::RecordInvalid => e
          render json: ErrorSerializer.format_error(ErrorMessage.new(e.message, 400)), status: :bad_request
        end

        private

        def invitee_params
          params.permit(:invitees_user_id)
        end
      end
    end
  end
end