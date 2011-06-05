require 'nokogiri'

module ITunes
  class Library
    def initialize(library_path)
      @doc    = Nokogiri.XML File.open(library_path)
      @tracks = []
      parse
    end
  
    def tracks
      @tracks || []
    end
  
    private
  
    def parse
      @doc.xpath('/plist/dict/dict/dict').each do |node|
        children = node.children.map(&:text).reject { |x| x.strip.empty? }
        @tracks << Track.new(Hash[children.each_cons(2).to_a])
      end
    end
  end
end