require 'net/http'
require 'timeout'

class GeoIP
  def initialize(geoip_host = 'freegeoip.net')
    @geoip_host = geoip_host
    @cache = {}
  end

  def call(env, cb = env['async.callback'])
    fw = env.fetch("HTTP_X_FORWARDED_FOR", "").split(",").last.to_s.strip
    ip = fw.presence || Rack::Request.new(env).ip

    @cache.clear if @cache.size > 1024 # magic values ftw!
    return @cache[ip] if @cache.include? ip

    if cb
      EM.defer { cb.call call(env, false) }
      return [-1, {}, []]
    end

    
    body = Timeout.timeout(5) { Net::HTTP.get(@geoip_host, "/json/#{ip}") }
    @cache[ip] = Rack::Response.new(body, 200, "Content-Type" => "application/json").finish
  rescue Timeout::Error
    [504, {"Content-Type" => "text/plain"}, ["GeoIP server did not respond properly."]]
  end
end
