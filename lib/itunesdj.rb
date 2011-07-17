require File.join(File.expand_path('..', __FILE__), 'itunes', 'track.rb')

class ITunesDJ
  attr_accessor :source, :minimum
  
  def initialize(playlist, source_playlist)
    @playlist = playlist
    @source   = source_playlist
    @source_tracks = []
  end
  
  def playlist
    @playlist
  end
  
  def minimum
    @minimum || 25
  end
  
  def current_track
    playlist.current_track
  end
  
  def queued_tracks
    range = (current_track.index)..(playlist.tracks.count - 1) unless current_track.nil?
    return playlist.tracks if range.nil?
    return [playlist.tracks[range.first]] if range.first == range.last # strange macruby bug here
    return playlist.tracks[range]
  end
  
  def populate
    (minimum - queued_tracks.count).times do
      next_track = pick_next_track
      playlist << next_track unless next_track.nil?
    end
  end
  
  def pick_next_track
    consider_source_tracks if @source_tracks.empty?
    track = @source_tracks.first
    @source_tracks.delete(track)
    return track
  end
  
  def enqueue_at_top(*tracks)
    playlist.unshift(tracks)
  end
  
  private
  
  def consider_source_tracks
    @source_tracks = []
    source.tracks.each { |t| @source_tracks << t }
    @source_tracks.select! { |t| !(t.queued? queued_tracks + [current_track]) }
    @source_tracks.sort! { |x,y| ensure_time(x.playedDate) <=> ensure_time(y.playedDate) }
  end
  
  def ensure_time(date)
    date || Time.at(0)
  end
end