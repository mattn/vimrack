require 'rack'
require 'vimrack'

map "/static" do
  run Rack::Directory.new("./static")
end

map "/" do
  run VimRack.new
end
