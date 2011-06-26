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
end