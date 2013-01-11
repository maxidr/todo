$:.unshift File.dirname(__FILE__)

require "cuba"
require "cuba/contrib"
require "mote"

Cuba.plugin Cuba::Mote

Cuba.use Rack::Static,
  root: 'public',
  urls: ['/js', '/css', '/img']

Cuba.define do
  on root do
    res.write view('home', title: 'to do list')
  end
end
