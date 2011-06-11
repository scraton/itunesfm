module ITunes
  autoload :Library, 'itunes/library'
  autoload :Artist, 'itunes/artist'
  autoload :Track, 'itunes/track'
  autoload :Playlist, 'itunes/playlist'
  
  def self.open(library_path)
    ITunes::Library.new library_path
  end
end