class UserProfileSerializer
  include JSONAPI::Serializer

  attributes :name, :username

  attribute :viewing_parties_hosted do |user|
    user.viewing_parties_hosted.map do |party|
      {
        id: party.id,
        name: party.name,
        start_time: party.start_time,
        end_time: party.end_time,
        movie_id: party.movie_id,
        movie_title: party.movie_title,
        host_id: party.host_id
      }
    end
  end

  attribute :viewing_parties_invited do |user|
    user.viewing_parties_attended.map do |party|
      next if party.host_id == user.id 

      {
        name: party.name,
        start_time: party.start_time,
        end_time: party.end_time,
        movie_id: party.movie_id,
        movie_title: party.movie_title,
        host_id: party.host_id
      }
    end.compact
  end
end
