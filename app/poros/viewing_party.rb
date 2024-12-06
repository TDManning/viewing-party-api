class ViewingParty
  attr_reader :name, 
              :start_time,
              :end_time,
              :movie_id,
              :movie_title,
              :host_id,

  def initialize(attributes)
    @name = attributes[:name]
    @start_time = attributes[:start_time]
    @end_time = attributes[:end_time]
    @movie_id = attributes[:movie_id]
    @movie_title = attributes[:movie_title]
    @host_id = attributes[:host_id]
  end
end