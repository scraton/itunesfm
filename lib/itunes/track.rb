module ITunes
  class Track
    attr_accessor :id, :title, :artist, :album, :genre, :time, :year, :bpm, :location, :played_at, :created_at, :updated_at
    
    def initialize(hash = {})
      self.id         = hash["Track ID"]
      self.title      = hash["Name"]
      self.artist     = Artist.new hash["Artist"]
      self.album      = hash["Album"]
      self.genre      = hash["Genre"]
      self.time       = hash["Time"]
      self.year       = hash["Year"]
      self.bpm        = hash["BPM"]
      self.location   = hash["Location"]
      self.played_at  = Time.new(hash["Play Date UTC"]) unless hash["Play Date UTC"].nil?
      self.created_at = Time.new(hash["Date Added"]) unless hash["Date Added"].nil?
      self.updated_at = Time.new(hash["Date Modified"]) unless hash["Date Modified"].nil?
    end
    
    def tags
      lastfm_track.tags.map(&:name)
    end
    
    protected
    
    def lastfm_track
      Rockstar::Track.new(self.artist.name, self.title)
    end
  end
end