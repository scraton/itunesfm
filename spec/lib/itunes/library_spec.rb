require 'spec_helper'

describe ITunes::Library do
  before(:all) do
    @itunes = ITunes.open File.expand_path('../../../fixtures/itunes.xml', __FILE__)
  end
  
  it "should detect all the tracks in an iTunes library" do
    @itunes.tracks.should have(4).things
  end
  
  it "should return a list of Tracks" do
    @itunes.tracks.first.should be_an_instance_of ITunes::Track
  end
end