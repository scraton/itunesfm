class ITunesDJ
  attr_accessor :source, :minimum
  
  def initialize(playlist, opts={})
    @playlist = playlist
  end
  
  def playlist
    @playlist
  end
  
  def source=(playlist)
    @source = playlist
  end
  
  def minimum
    @minimum || 25
  end
  
  def current_track
    playlist.current_track
  end
  
  def queued_tracks
    return playlist.tracks[(current_track.index)..(playlist.tracks.count - 1)] unless current_track.nil?
    return playlist.tracks
  end
  
  def populate
    (minimum - queued_tracks.count).times do
      next_track = pick_next_track
      playlist << next_track unless next_track.nil?
    end
  end
  
  def pick_next_track
    tracks = source_tracks
    queued_track_ids = queued_tracks.map(&:persistentID)
    tracks.select! { |t| !(queued_track_ids.include? t.persistentID) }
    tracks.sort! { |x,y| ensure_time(x.playedDate) <=> ensure_time(y.playedDate) }
    tracks.first
  end
  
  private
  
  def source_tracks
    @source_tracks = []
    source.tracks.each { |t| @source_tracks << t }
    @source_tracks
  end
  
  def ensure_time(date)
    date || Time.at(0)
  end
end