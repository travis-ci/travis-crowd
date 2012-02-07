require 'soundcloud'

class Track < Soundcloud::Model
  def self.uri
    'me/tracks'
  end

  # working around a strange soundcloud bug
  def self.all
    @all ||= Playlist.all.map(&:tracks).flatten(1)
  end

  def download_url
    Array(Soundcloud.head(super)['location']).first
  end
end
