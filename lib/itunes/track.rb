class ITunesTrack
  MediaKinds = {
    ITunesESpKNone => :none,
    ITunesEVdKMovie => :movie,
    ITunesEVdKMusicVideo => :music_video,
    ITunesEVdKNone => :none,
    ITunesEVdKTVShow => :tv_show
  }

  def to_s
    by = artist || albumArtist || '(unknown artist)'
    "#{by} - #{name}"
  end
  
  def queued?(queue)
    queue.map(&:persistentID).include? self.persistentID
  end
  
  def video_kind
    MediaKinds[self.videoKind]
  end
  
  def inspect
    %(#<#{self.class.name}:#{self}>)
  end
end