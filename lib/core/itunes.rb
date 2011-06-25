#
# Many thanks to mislav for this
# https://github.com/mislav/itunes
#

module ITunes
  def self.app
    @app ||= SBApplication.applicationWithBundleIdentifier('com.apple.itunes').tap do
      # $ sdef /Applications/iTunes.app | sdp -fh --basename iTunes
      # $ gen_bridge_metadata -c '-I.' iTunes.h > iTunes.bridgesupport
      load_bridge_support_file 'iTunes.bridgesupport'
    end
  end

  self.app
  
  def self.library
    @library ||= app.sources['Library']
  end
  
  def self.music
    library.userPlaylists['Music']
  end

  PlayerStates = {
    ITunesEPlSStopped => :stopped,
  	ITunesEPlSPlaying => :playing,
  	ITunesEPlSPaused => :paused,
  	ITunesEPlSFastForwarding => :fast_forwarding,
  	ITunesEPlSRewinding => :rewinding
  }
  
  def self.player_state
    PlayerStates[app.playerState]
  end
  
  def self.current_track
    ensure_found app.currentTrack
  end

  def self.find_playlist(name)
    ensure_found library.userPlaylists[name]
  end

  class << self
    private
    def ensure_found(item)
      # work around the fact that iTunesItem lookups will often
      # return an object regardless of whether it actually exists
      item.id == 0 ? nil : item
    end
  end
end

require File.join(File.expand_path('..', __FILE__), 'ext.rb')