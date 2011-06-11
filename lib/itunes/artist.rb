require 'rockstar'

module ITunes
  class Artist
    attr_accessor :name
    
    def initialize(name)
      self.name = name
    end
    
    def tags
      lastfm_artist.top_tags.map(&:name)
    end
    
    protected
    
    def lastfm_artist
      Rockstar::Artist.new(self.name)
    end
  end
end