$:.unshift File.dirname(__FILE__)

require File.expand_path("settings", File.dirname(__FILE__))

require "cuba"
require "cuba/contrib"
require "mote"
require "ohm"
require "securerandom"

Cuba.plugin Cuba::Mote

Cuba.use Rack::MethodOverride
Cuba.use Rack::Session::Cookie, :secret => SecureRandom.hex(64)
Cuba.use Rack::Static,
  root: 'public',
  urls: ['/js', '/css', '/img']

Ohm.connect(url: Settings::REDIS_URL)

Dir["./models/**/*.rb"].each  { |rb| require rb }
Dir["./lib/**/*.rb"].each  { |rb| require rb }
Dir["./routes/**/*.rb"].each  { |rb| require rb }

Cuba.plugin Helpers

Cuba.define do
  on root do
    view_home
  end

  on 'tasks' do
    run Tasks
  end

  on 'lists' do
    run Lists
  end
  
end
