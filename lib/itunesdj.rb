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
  
  def populate
    (minimum - playlist.tracks.count).times do |i|
      playlist << source.tracks[i] if i < source.tracks.count
    end
  end
end