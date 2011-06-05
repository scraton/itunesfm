require 'spec_helper'

describe ITunes::Track do
  it "should allow creating a blank track" do
    ITunes::Track.new.should be_a ITunes::Track
  end
  
  context "should take a hash of attributes" do
    before { @track = ITunes::Track.new({"Name"=>"Me & U", "Artist"=>"Cassie"}) }
    
    it "should assign the track title" do
      @track.title.should == "Me & U"
    end
    
    it "should assign the track artist" do
      @track.artist.should be_an ITunes::Artist
    end
    
    context "track times" do
      before { @track = ITunes::Track.new({"Play Date UTC" => "2011-01-01T00:00:00Z", "Date Added" => "2011-01-01T00:00:00Z", "Date Modified" => "2011-01-01T00:00:00Z"}) }
      
      %w(played_at created_at updated_at).each do |a|
        it { @track.send(a).should be_a Time }
      end
    end
  end
end