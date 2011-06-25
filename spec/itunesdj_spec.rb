require File.join File.expand_path('..', __FILE__), '..', 'lib', 'itunesdj.rb'

describe ITunesDJ do
  let(:djplaylist) { mock("ITunesUserPlaylist") }
  let(:source) { mock("ITunesUserPlaylist") }
  let(:itunesdj) { ITunesDJ.new(djplaylist) }
  let(:tracks) { [mock("ITunesTrack", :playedDate => Time.now), mock("ITunesTrack", :playedDate => Time.now)] }
    
  it "should initialize off the iTunes DJ Playlist" do
    itunesdj.should be
  end
  
  it "should allow tracking of a source playlist" do
    itunesdj.source = source
    itunesdj.source.should == source
  end
  
  context "#populate" do
    before do
      itunesdj.source = source
      djplaylist.stub!(:tracks).and_return([])
      source.stub!(:tracks).and_return(tracks)
    end
    
    it "should populate songs off the source" do
      tracks.each { |t| djplaylist.should_receive(:<<).with(t) }
      itunesdj.populate
    end
  
    context "minimum" do
      before { itunesdj.minimum = 1 }
      
      it "should only populate up to the minimum number of songs" do
        djplaylist.should_receive(:<<).with(tracks.first)
        itunesdj.populate
      end
      
      it "shouldn't go over the minimum if there are existing tracks" do
        djplaylist.stub!(:tracks).and_return(tracks)
        djplaylist.should_not_receive(:<<)
        itunesdj.populate
      end
    end
  end
end