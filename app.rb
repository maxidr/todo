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

Cuba.plugin Helpers

Cuba.define do
  on root do
    view_home
  end

  on post do
    on 'tasks', param('task') do |params|
      task = Task.new(params)
      
      if task.save
        res.redirect '/', 303
      else
        view_home(task: task)
      end
    end

    on 'lists', param('list') do |params|
      list = TaskList.new(params)
      if list.save
        res.redirect '/', 303
      else
        view_home(list: list)
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
