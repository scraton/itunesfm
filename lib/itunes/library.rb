require 'nokogiri'

module ITunes
  class Library
    attr :tracks, true
    attr :artists, true
    attr :playlists, true
    
    def initialize(library_path)
      @doc       = Nokogiri.XML File.open(library_path)
      @artists   = []
      @tracks    = []
      @playlists = []
      parse
    end
    
    def tags
      tags = []
      artists.each do |artist|
        tags += artist.tags[0..9]
      end
      tags
    end
    
    private
  
    def parse
      parse_tracks
      parse_playlists
    end
    
    def parse_tracks
      @doc.xpath('/plist/dict/dict/dict').each do |node|
        children = node.children.map(&:text).reject { |x| x.strip.empty? }
        
        hash     = Hash[children.each_cons(2).to_a]
        artist   = @artists.detect { |a| a.name == hash["Artist"] }
        
        track    = Track.new hash
        @artists << track.artist if artist.nil?
        artist ||= track.artist
        
        @tracks  << track
      end
    end
    
    def parse_playlists
      @doc.xpath('/plist/dict/array/dict').each do |node|
        children = node.children.map(&:text).reject { |x| x.strip.empty? }
        hash     = Hash[children.each_cons(2).to_a]
        
        @playlists << ITunes::Playlist.new(hash["Name"])
        playlist = @playlists.last
        
        node.xpath('array/dict').each do |track|
          children  = track.children.map(&:text).reject { |x| x.strip.empty? }
          hash      = Hash[children.each_cons(2).to_a]
          playlist.tracks << @tracks.detect {|t| t.id == hash["Track ID"] }
        end
      end
    end
  end
end