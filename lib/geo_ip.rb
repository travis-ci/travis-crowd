require 'net/http'
require 'timeout'

class GeoIP
  TRUSTED_PROXY = /^127\.0\.0\.1$|^(10|172\.(1[6-9]|2[0-9]|30|31)|192\.168)\.|^::1$|^fd[0-9a-f]{2}:.+|^localhost$/i
  def initialize(geoip_host = 'freegeoip.net')
    @geoip_host = geoip_host
    @cache = {}
  end

  def call(env, cb = env['async.callback'])
    [504, {"Content-Type" => "text/plain"}, env.select { |k,v| String === v }.map { |k,v| "#{k}: #{v.inspect}\n" }]
    # forwarded_ips = env['HTTP_X_FORWARDED_FOR'] ? env['HTTP_X_FORWARDED_FOR'].strip.split(/[,\s]+/) : []
    #     ip = forwarded_ips.reject { |ip| ip =~ TRUSTED_PROXY }.last || env['REMOTE_ADDR']
    # 
    #     @cache.clear if @cache.size > 1024 # magic values ftw!
    #     return @cache[ip] if @cache.include? ip
    # 
    #     if cb
    #       EM.defer { cb.call call(env, false) }
    #       return [-1, {}, []]
    #     end
    # 
    #     
    #     body = Timeout.timeout(5) { Net::HTTP.get(@geoip_host, "/json/#{ip}") }
    #     @cache[ip] = Rack::Response.new(body, 200, "Content-Type" => "application/json").finish
  rescue Timeout::Error
    [504, {"Content-Type" => "text/plain"}, ["GeoIP server did not respond properly."]]
  end
end
