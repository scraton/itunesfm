class ITunesTrack
  def to_s
    by = artist || albumArtist || '(unknown artist)'
    "#{by} - #{name}"
  end
  
  def queued?(queue)
    queue.map(&:persistentID).include? self.persistentID
  end
  
  def not_queued?(queue)
    !queued?(queue)
  end
  
  def inspect
    %(#<#{self.class.name}:#{self}>)
  end
end