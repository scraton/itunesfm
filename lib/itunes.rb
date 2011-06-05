require 'itunes/library'
require 'itunes/track'

module ITunes
  def self.open(library_path)
    ITunes::Library.new library_path
  end
end