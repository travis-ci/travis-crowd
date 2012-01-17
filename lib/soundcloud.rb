require 'net/http'
require 'net/https'
require 'json'

module Soundcloud
  class Model < Hashr
    extend Enumerable

    def self.all
      @all ||= Soundcloud.get(uri).map { |p| new(p) }
    end

    def self.each(&block)
      all.each(&block)
    end

    def self.find(id_or_hash)
      id_or_hash = {id: id_or_hash} if Integer === id_or_hash
      detect { |e| id_or_hash.all? { |k,v| e[k] == v } }
    end

    def inspect
      "#<#{self.class}: #{title.inspect}>"
    end
  end

  extend self

  def get(url)
    JSON.parse(http.request_get(url_for(url + ".json")).body)
  end

  def head(url)
    http.request_head(url_for(url)).to_hash
  end

  def http
    @http ||= begin
      connection = Net::HTTP.new('api.soundcloud.com', 443)
      connection.use_ssl = true
      connection
    end
  end

  def url_for(url)
    "/#{url.sub(%r{^(https?://api.soundcloud.com)?/?}, '')}?oauth_token=#{oauth_token}"
  end

  def oauth_token
    Rails.application.config.settings[:soundcloud][:oauth_token]
  end
end
