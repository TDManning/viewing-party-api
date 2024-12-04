class MovieSerializer
  include JSONAPI::Serializer
  set_type :movie
  attributes :title, :vote_average
end