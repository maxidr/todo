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
Dir["./lib/**/*.rb"].each  { |rb| require rb }

Cuba.plugin Helpers

Cuba.define do
  on root do
    view_home
  end

  on post do
    on 'tasks', param('task'), param('on_list') do |params, on_list|
      list = TaskList[on_list]
      task = Task.new(params.merge(done: false, on_list: list))
      
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
