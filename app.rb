$:.unshift File.dirname(__FILE__)

require "cuba"
require "cuba/contrib"
require "mote"
require "ohm"

Cuba.plugin Cuba::Mote

Cuba.use Rack::Static,
  root: 'public',
  urls: ['/js', '/css', '/img']

Ohm.connect(url: 'redis://127.0.0.1:6379/0')

Dir["./models/**/*.rb"].each  { |rb| require rb }

Cuba.define do
  on root do
    #res.write view('home', title: 'to do list')
    render 'home', title: 'to do list'
  end

  on 'tasks' do
    on post, param('title') do |title|
      Task.create(title: title, done: false)
      res.redirect '/', 303
    end
  end
end
