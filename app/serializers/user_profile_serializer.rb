class UserProfileSerializer
  def initialize(user)
    @user = user
  end

  def serializable_hash
    {
      data: {
        id: @user.id.to_s,
        type: 'user',
        attributes: {
          name: @user.name,
          username: @user.username,
          viewing_parties_hosted: hosted_parties,
          viewing_parties_invited: invited_parties
        }
      }
    }
  end

  private

  def hosted_parties
    @user.hosted_parties.map do |party|
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

  def invited_parties
    @user.invited_parties.map do |party|
      {
        name: party.name,
        start_time: party.start_time,
        end_time: party.end_time,
        movie_id: party.movie_id,
        movie_title: party.movie_title,
        host_id: party.host_id
      }
    end
  end
end
