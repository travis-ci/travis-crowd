use Rack::Static, :urls => Dir['**/*'].map { |path| "/#{path}" }
run lambda{ |env| [ 404, { 'Content-Type'  => 'text/html' }, ['404 - page not found'] ] }
