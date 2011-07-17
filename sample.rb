#!/usr/local/bin/macruby
framework 'Foundation'
framework 'ScriptingBridge'

require File.join(File.expand_path('..', __FILE__), 'lib', 'core', 'itunes.rb')
require File.join(File.expand_path('..', __FILE__), 'lib', 'itunesdj.rb')

ITunes.app.run

sources = ["2011 Summer", "12hrs of Most Played (genre specific)", "Top 100 Most Played", "Top 100 Most Played (not within 1 mo)", "Taylor Swift", "Remember and New"].map do |playlist|
  ITunes.find_playlist(playlist)
end

source = ITunes.find_playlist("Recently Added")
puts "Using '#{source.name}' as initial DJ source."

dj = ITunesDJ.new(ITunes.find_playlist("iTunes DJ"), source)
dj.playlist.delete_all

while true
  begin
    # Play 'Darkside Radio' every 15 minutes
    dj.enqueue_at_top ITunes.music.search("Darkside Radio").sample if Time.now.min % 15 == 0 && Time.now.sec == 0
    
    # Change source every other hour
    if Time.now.hour.even? && Time.now.min == 0 && Time.now.sec == 0
      dj.source = sources.sample
      dj.playlist.delete_all
      puts "[#{Time.now}] Changed source to #{dj.source.name}"
    end
    
    dj.populate
  ensure
    sleep 1
  end
end