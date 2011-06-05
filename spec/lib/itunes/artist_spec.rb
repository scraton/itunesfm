require 'spec_helper'

describe ITunes::Artist do
  context "should take the artist name" do
    before { @artist = ITunes::Artist.new("Cassie") }
    
    it "should assign the track artist" do
      @artist.name.should == "Cassie"
    end
  end
  
  context "lastfm" do
    around(:each) do |example|
      VCR.use_cassette("artist_tags",
                  :record => :new_episodes,
                  &example)
    end
    
    before { @artist = ITunes::Artist.new("Taylor Swift") }
    
    it "should give a list of tags" do
      @artist.tags[0..10].should == ["country", "female vocalists", "pop", "singer-songwriter", "acoustic", "taylor swift", "country pop", "american", "female", "female vocalist", "contemporary country"]
    end
  end
end