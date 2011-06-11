module ITunes
  class Playlist
    attr_accessor :name, :tracks
    
    def initialize(name)
      @name   = name
      @tracks = []
    end
  end
end