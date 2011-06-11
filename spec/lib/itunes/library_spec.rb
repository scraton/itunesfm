# coding: utf-8
require 'spec_helper'

describe ITunes::Library do
  let(:library) { ITunes.open File.expand_path('../../../fixtures/itunes.xml', __FILE__) }
  
  it "should detect all the tracks in an iTunes library" do
    library.tracks.should have(4).things
  end
  
  it "should return a list of Tracks" do
    library.tracks.first.should be_an_instance_of ITunes::Track
  end
  
  context "artists" do
    subject { library.artists }
    it { should have(3).things }
    
    it { library.artists.first.should be_an_instance_of ITunes::Artist }
  end
  
  context "playlists" do
    it "should give me a list of playlists" do
      library.playlists.map(&:name).should == ["Library","Music","Movies","TV Shows","Podcasts","Books","iTunes DJ","90’s Music","Classical Music","Music Videos","My Top Rated","Recently Added","Recently Played","Top 25 Most Played","My Playlist"]
    end
    
    it "should have a list of Tracks" do
      library.playlists.first.tracks.first.should be_an_instance_of ITunes::Track
    end
  end
  
  context "lastfm" do
    around(:each) do |example|
      VCR.use_cassette("artist_tags",
                  :record => :new_episodes,
                  &example)
    end
    
    it "should aggregate all tags in my library based on artists" do
      library.tags.should == ["chillout", "trip-hop", "electronic", "lounge", "downtempo", "french", "electronica", "chill", "france", "female vocalists", "country", "female vocalists", "pop", "singer-songwriter", "acoustic", "taylor swift", "country pop", "american", "female", "female vocalist", "rnb", "female vocalists", "pop", "Hip-Hop", "dance", "cassie", "hip hop", "r&amp;b", "american", "sexy"]
    end
  end
end