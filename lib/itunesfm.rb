class ITunesFM
  attr_accessor :library, :db
  
  def initialize(library, opts={})
    @library = library
    @db      = opts[:db]
    
    initialize_db
  end
  
  def tag_artists
    library.artists.each do |artist|
      db[:artists].insert :name => artist.name if db[:artists].where(:name => artist.name).empty?
      artist.tags.each do |tag|
        db[:tags].insert :tag => tag if db[:tags].where(:tag => tag).empty?
      end
    end
  end
  
  private
  
  def initialize_db
    db.create_table :tags do
      primary_key :id
      String :tag, :unique => true, :null => false
    end
    
    db.create_table :artists do
      primary_key :id
      String :name, :unique => true, :null => false
    end
  end
end