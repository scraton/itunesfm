require 'nokogiri'

module ITunes
  class Library
    def initialize(library_path)
      @doc     = Nokogiri.XML File.open(library_path)
      @tracks  = []
      @artists = {}
      parse
    end
  
    def tracks
      @tracks
    end
    
    def artists
      @artists.map(&:last)
    end
  
    private
  
    def parse
      @doc.xpath('/plist/dict/dict/dict').each do |node|
        children = node.children.map(&:text).reject { |x| x.strip.empty? }
        
        hash     = Hash[children.each_cons(2).to_a]
        artist   = @artists[hash["Artist"].to_s] if @artists.key? hash["Artist"].to_s
        
        track    = Track.new hash
        artist ||= track.artist
        
        @artists[artist.name.to_s] = artist
        @tracks  << track
      end
    end
  end
end