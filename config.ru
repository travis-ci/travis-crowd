# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
require 'order_stream'

map('/') { run Travis::Application }
map('/orders.es') { run OrderStream }
