$:.unshift File.expand_path('..', __FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)

require 'fileutils'
require 'rubygems'
require 'bundler'
require 'rspec'

require 'itunes'

Dir["#{File.expand_path('../support', __FILE__)}/*.rb"].each do |file|
  require file
end

# RSpec::Rubygems.setup

RSpec.configure do |config|
end
