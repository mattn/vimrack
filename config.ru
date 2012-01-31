require 'rack'
require 'vimrack'

#app = Rack::Builder.new do
#end

map "/static" do
  run Rack::Directory.new("./static")
end

map "/" do
  run VimRack.new
end
