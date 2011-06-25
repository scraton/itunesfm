class SBElementArray
  def [](value)
    self.objectWithName(value)
  end
end

class ITunesPlaylist
  SearchFilters = {
    albums: ITunesESrAAlbums,
    all: ITunesESrAAll,
    artists: ITunesESrAArtists,
    composers: ITunesESrAComposers,
    visible: ITunesESrADisplayed, # visible text fields
    songs: ITunesESrASongs
  }

  def search(query, filter = :visible)
    searchFor(query, only:SearchFilters[filter])
  end
end

class ITunesUserPlaylist
  def inspect
    %(#<#{self.class.name}:#{self.name}>)
  end
  
  def <<(track)
    track.duplicateTo(self)
    self
  end
  
  def add(tracks)
    Array(tracks).each { |t| self << t }
    self
  end
end

class ITunesTrack
  def to_s
    by = artist || albumArtist || '(unknown artist)'
    "#{by} - #{name}"
  end
  
  def inspect
    %(#<#{self.class.name}:#{self}>)
  end
end