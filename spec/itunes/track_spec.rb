require 'spec_helper'
require File.join File.expand_path('..', __FILE__), '..', '..', 'lib', 'itunes', 'track.rb'

describe ITunesTrack do
  context "#queued?" do
    before do
      @track = ITunesTrack.new
      @track.stub!(:persistentID).and_return('8789EA430AB2EE84')
    end
    
    it "should be queued if that track exists in an array" do
      @track.queued?([@track]).should be
    end
    
    it "should not be queued if that track does not exist" do
      another_track = ITunesTrack.new
      another_track.stub!(:persistentID).and_return('E5F06E038A125D7F')
      @track.queued?([another_track]).should_not be
    end
  end
  
  context "#video_kind" do
    let(:track) { ITunesTrack.new }
    
    [ITunesESpKNone, ITunesEVdKNone].each do |kind|
      it "should return :none for #{kind}" do
        track.stub!(:videoKind).and_return(kind)
        track.video_kind.should == :none
      end
    end
    
    it "should return :movie for ITunesEVdKMovie" do
      track.stub!(:videoKind).and_return(ITunesEVdKMovie)
      track.video_kind.should == :movie
    end
    
    it "should return :music_video for ITunesEVdKMusicVideo" do
      track.stub!(:videoKind).and_return(ITunesEVdKMusicVideo)
      track.video_kind.should == :music_video
    end
    
    it "should return :tv_show for ITunesEVdKTVShow" do
      track.stub!(:videoKind).and_return(ITunesEVdKTVShow)
      track.video_kind.should == :tv_show
    end
  end
end