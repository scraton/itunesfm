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
  
  def insert(index, tracks)
    skip   = top_offset
    copied = 0
    
    self.tracks.each_with_index do |track, i|
      next if i < skip
      self.add(tracks) if i - skip == index
      self << track
      copied += 1
    end
    
    (copied - 1).downto(0) do
      self.tracks[skip].delete
    end
  end
  
  def unshift(tracks)
    insert(0, tracks)
  end
  
  def delete_all
    while self.tracks[top_offset]
      self.tracks[top_offset].delete
    end
  end
  
  def add(tracks)
    tracks.to_a.each { |t| self << t }
    self
  end
  
  def track_ids
    tracks.map(&:persistentID)
  end
  
  def top_offset
    return current_track.index if current_track && name == "iTunes DJ"
    return 0
  end
  
  def current_track
    return nil if ITunes.current_track.nil?
    ITunes.current_track if track_ids.include? ITunes.current_track.persistentID
  end
end