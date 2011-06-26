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
  
  context "#current_track" do
    it "should return the current track" do
      djplaylist.should_receive(:current_track)
      itunesdj.current_track
    end
  end
  
  context "#queued_tracks" do
    it "should only count tracks that are yet to be played" do
      tracks = [
        mock("ITunesTrack", :playedDate => Time.now - 60,  :persistentID => '8789EA430AB2EE84', :index => 1),
        mock("ITunesTrack", :playedDate => Time.now - 240, :persistentID => 'E5F06E038A125D7F', :index => 2),
        mock("ITunesTrack", :playedDate => Time.now - 120, :persistentID => 'CE8D90D2B7C475D5', :index => 3)
      ]
      djplaylist.stub!(:tracks).and_return(tracks)
      djplaylist.stub!(:current_track).and_return(tracks[1])
      itunesdj.queued_tracks.should == tracks[2..2]
    end
  end
  
  context "#populate" do
    before do
      itunesdj.source = source
      djplaylist.stub!(:current_track).and_return(nil)
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
      
      it "should populate queued tracks, not past tracks" do
        tracks = [
          mock("ITunesTrack", :playedDate => Time.now - 60,  :persistentID => '8789EA430AB2EE84', :index => 1),
          mock("ITunesTrack", :playedDate => Time.now - 240, :persistentID => 'E5F06E038A125D7F', :index => 2)
        ]
        djplaylist.stub!(:tracks).and_return(tracks)
        djplaylist.stub!(:current_track).and_return(tracks[1])
        djplaylist.should_receive(:<<)
        itunesdj.populate
      end
    end
  end
end