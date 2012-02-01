# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

#require 'geo_ip'
map('/') { run Travis::Application }
#map('/geo_ip.json') { run GeoIP.new }
