require File.join File.expand_path('..', __FILE__), '..', 'lib', 'itunesdj.rb'

describe ITunesDJ do
  let(:djplaylist) { mock("ITunesUserPlaylist") }
  let(:source) { mock("ITunesUserPlaylist") }
  let(:itunesdj) { ITunesDJ.new(djplaylist, source) }
  let(:tracks) { [mock(ITunesTrack, :playedDate => Time.now), mock(ITunesTrack, :playedDate => Time.now)] }
    
  it "should initialize off the iTunes DJ Playlist" do
    itunesdj.should be
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
        mock(ITunesTrack, :playedDate => Time.now - 60,  :persistentID => '8789EA430AB2EE84', :index => 1),
        mock(ITunesTrack, :playedDate => Time.now - 240, :persistentID => 'E5F06E038A125D7F', :index => 2),
        mock(ITunesTrack, :playedDate => Time.now - 120, :persistentID => 'CE8D90D2B7C475D5', :index => 3)
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
      itunesdj.stub!(:pick_next_track).and_return(tracks.first)
    end
    
    it "should populate songs off the source" do
      djplaylist.should_receive(:<<).exactly(itunesdj.minimum).times
      itunesdj.should_receive(:pick_next_track).exactly(itunesdj.minimum).times
      itunesdj.populate
    end
  
    context "minimum" do
      before { itunesdj.minimum = 1 }
      
      it "should only populate up to the minimum number of songs" do
        djplaylist.should_receive(:<<).with(tracks.first).exactly(1).times
        itunesdj.populate
      end
      
      it "shouldn't go over the minimum if there are existing tracks" do
        djplaylist.stub!(:tracks).and_return(tracks)
        djplaylist.should_not_receive(:<<)
        itunesdj.populate
      end
      
      it "should populate queued tracks, not past tracks" do
        tracks = [
          mock(ITunesTrack, :playedDate => Time.now - 60,  :persistentID => '8789EA430AB2EE84', :index => 1),
          mock(ITunesTrack, :playedDate => Time.now - 240, :persistentID => 'E5F06E038A125D7F', :index => 2)
        ]
        djplaylist.stub!(:tracks).and_return(tracks)
        djplaylist.stub!(:current_track).and_return(tracks[1])
        djplaylist.should_receive(:<<)
        itunesdj.populate
      end
    end
  end
  
  context "#pick_next_track" do
    let(:source_tracks) do
      [
        mock(ITunesTrack, :playedDate => Time.now,       :queued? => true),
        mock(ITunesTrack, :playedDate => Time.now - 60,  :queued? => false),
        mock(ITunesTrack, :playedDate => Time.now - 240, :queued? => false)
      ]
    end
    
    before do
      source.stub!(:tracks).and_return(source_tracks)
      itunesdj.stub!(:current_track).and_return(nil)
      djplaylist.stub!(:tracks).and_return([])
    end
    
    it "should return the track that hasn't been played the longest" do
      itunesdj.pick_next_track.should == source_tracks.last
    end
    
    it "should not pick a song that's already queued" do
      source_tracks.last.stub!(:queued?).and_return(true)
      itunesdj.pick_next_track.should_not == source_tracks.last
    end
  end
  
  context "#enqueue_at_top" do
    it "should play the track at the top of the list" do
      top_track = mock(ITunesTrack, :name => "Top Track")
      djplaylist.stub!(:tracks).and_return(tracks)
      djplaylist.should_receive(:unshift).with([top_track])
      itunesdj.enqueue_at_top(top_track)
    end
  end
end