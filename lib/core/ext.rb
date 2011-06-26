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
  
  def track_ids
    tracks.map(&:persistentID)
  end
  
  def current_track
    return nil if ITunes.current_track.nil?
    ITunes.current_track if track_ids.include? ITunes.current_track.persistentID
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