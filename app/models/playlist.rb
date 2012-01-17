require 'soundcloud'
require 'hashr'

class Playlist < Soundcloud::Model
  def self.uri
    'me/playlists'
  end

  def tracks
    @tracks ||= super.map { |t| Track.new(t) }
  end
end