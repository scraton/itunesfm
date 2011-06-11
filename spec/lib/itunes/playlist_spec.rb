require 'spec_helper'

describe ITunes::Playlist do
  it "should initialize a Playlist given a name" do
    ITunes::Playlist.new("My Playlist").name.should == "My Playlist"
  end
end