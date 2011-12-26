# urls = Dir['**/*.*']
# urls = Hash[*urls.map { |path| "/#{path}" }.zip(urls).flatten]
# urls.merge!('/' => 'index.html')
#
# use Rack::Static, :urls => urls, :root => '.'
# run lambda{ |env| [ 404, { 'Content-Type'  => 'text/html' }, ['404 - page not found'] ] }

use Rack::Static,
  :urls =>  Dir['*'].map { |path| "/#{path}" },
  :root => "."

run lambda { |env|
  if env['PATH_INFO'] == '/'
    [ 200, { 'Content-Type'  => 'text/html', 'Cache-Control' => 'public, max-age=86400' }, File.open('index.html', File::RDONLY) ]
  else
    [ 404, { 'Content-Type'  => 'text/html' }, ["404 - not found: #{env['PATH_INFO']}"] ]
  end
}
