require 'spec_helper'

describe ITunesFM do
  let(:db) { Sequel.sqlite }
  let(:library) { mock(ITunes::Library) }
  let(:itunesfm) { ITunesFM.new(library, :db => db) }
  
  context "#tag_artists" do
    before do
      library.stub(:artists).and_return([
        mock(ITunes::Artist, :name => "Taylor Swift", :tags => ["country", "singer-songwriter"]),
        mock(ITunes::Artist, :name => "Telepopmusik", :tags => ["electronic"])
      ])
      itunesfm.tag_artists
    end
  
    it "should save the libraries tags to a datastore" do
      db[:tags].all.should have(3).things
    end
  
    it "should save the artists to a datastore" do
      db[:artists].all.should have(2).things
    end
  end
end