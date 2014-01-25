$:.unshift File.expand_path("./../lib", __FILE__)
map "/public" do
  run Rack::Directory.new("./public")
end
require 'bundler'
Bundler.require

require 'app'

run IdeaBoxApp
