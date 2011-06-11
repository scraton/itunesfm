#!/usr/bin/env ruby
$:.unshift File.expand_path('../..', __FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)

require 'rubygems'
require 'bundler'

# Bundler.require(:default, :test, :development)
require File.expand_path('../../spec/spec_helper.rb', __FILE__)

require 'itunes'
require 'optparse'

options = {}

optparse = OptionParser.new do|opts|
  opts.banner = "Usage: tagify.rb [options] library_file"

  options[:db] = nil
  opts.on( '--db FILE', 'Save tag information to this SQLite data store.' ) do |file|
    options[:db] = file
  end

  opts.on( '-h', '--help', 'Display this screen' ) do
    puts opts
    exit
  end
end

optparse.parse!

unless !ARGV.first.nil? && File.exist?(ARGV.first)
  puts "iTunes Library File #{ARGV.first} not found."
  Kernel.abort
end

