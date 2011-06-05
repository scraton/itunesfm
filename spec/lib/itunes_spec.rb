require 'spec_helper'

describe ITunes do
  it "should give me a Library given an iTunes XML path" do
    ITunes.open(File.expand_path('../../fixtures/itunes.xml', __FILE__)).class.should == ITunes::Library
  end
end