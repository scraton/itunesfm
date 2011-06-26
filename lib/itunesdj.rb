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
    (minimum - queued_tracks.count).times do |i|
      playlist << source.tracks[i] if i < source.tracks.count
    end
  end
end