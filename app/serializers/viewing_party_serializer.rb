class ViewingPartySerializer
  include JSONAPI::Serializer
  attributes :name, :start_time, :end_time, :movie_id, :movie_title, :host_id

  def self.format_viewing_party_list(viewing_parties)
    { data:
        viewing_parties.map do |viewing_party|
          {
            id: viewing_party.id.to_s,
            type: "viewing_party",
            attributes: {
              name: viewing_party.name,
              start_time: viewing_party.start_time,
              end_time: viewing_party.end_time,
              movie_id: viewing_party.movie_id,
              movie_title: viewing_party.movie_title,
              host_id: viewing_party.host_id
            }
          }
        end
    }
  end
end