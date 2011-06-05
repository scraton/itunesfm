$:.unshift File.expand_path('..', __FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)

require 'fileutils'
require 'rubygems'
require 'bundler'
require 'rspec'

require 'fakeweb'
require 'vcr'

require 'itunes'

Dir["#{File.expand_path('../support', __FILE__)}/*.rb"].each do |file|
  require file
end

VCR.config do |c|
  c.cassette_library_dir     = 'spec/cassettes'
  c.stub_with                :fakeweb
  c.default_cassette_options = { :record => :new_episodes }
end

Rockstar.lastfm = {"api_key" => "abcdefghijklmnopqrstuvwxyz", "secret" => "1234567890"}

RSpec.configure do |config|
end
