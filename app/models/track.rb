require 'soundcloud'

class Track < Soundcloud::Model
  def self.uri
    'me/tracks'
  end

  def download_url
    Array(Soundcloud.head(super)['location']).first
  end
end
