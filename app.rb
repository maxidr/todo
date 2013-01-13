$:.unshift File.dirname(__FILE__)

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

Ohm.connect(url: 'redis://127.0.0.1:6379/0')

Dir["./models/**/*.rb"].each  { |rb| require rb }


Cuba.define do
  on root do
    res.write view('home', title: 'to do list', task: Task.new)
  end

  on post do
    on 'tasks', param('task') do |params|
      task = Task.new(params.merge(done: false))
      
      if task.save
        res.redirect '/', 303
      else
        res.write view('home', title: 'to do list', task: task)
      end
    end
  end

  on put do
    on 'tasks/:id', param('task') do |id, params|
      task = Task[id]
      task.update(params)
      res.redirect '/', 303
    end
  end
end
