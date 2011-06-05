require 'spec_helper'

describe ITunes::Artist do
  context "should take the artist name" do
    before { @artist = ITunes::Artist.new("Cassie") }
    
    it "should assign the track artist" do
      @artist.name.should == "Cassie"
    end
  end
end