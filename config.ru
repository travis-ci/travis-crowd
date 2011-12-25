urls = Dir['**/*'].map { |path| "/#{path}" }
urls = Hash[*urls.zip(urls).flatten]
urls.merge!('/' => 'index.html')

use Rack::Static, :urls => urls
run lambda{ |env| [ 404, { 'Content-Type'  => 'text/html' }, ['404 - page not found'] ] }
