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
    if (Time.now.min % 15).zero? && Time.now.sec.zero?
      puts "[#{Time.now}] Imaging time!"
      dj.enqueue_at_top ITunes.music.search("Darkside Radio").sample
    end
    
    # Change source every other hour
    if Time.now.hour.even? && Time.now.min.zero? && Time.now.sec.zero?
      puts "[#{Time.now}] Changing source to #{dj.source.name}"
      dj.source = sources.sample
      dj.playlist.delete_all
    end
    
    dj.populate
  ensure
    sleep 1
  end
end