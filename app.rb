$:.unshift File.dirname(__FILE__)

require "cuba"
require "cuba/contrib"
require "mote"
require "ohm"

Cuba.use Rack::Static,
  root: 'public',
  urls: ['/js', '/css', '/img']

Ohm.connect(url: 'redis://127.0.0.1:6379/0')

Dir["./models/**/*.rb"].each  { |rb| require rb }

Cuba.plugin Cuba::Mote

Cuba.define do

  on root do
    res.write view('home', title: 'to do list', task: Task.new)
  end

  on 'tasks' do
    on post, param('task') do |params|
      task = Task.new(params)
      
      if task.save
        res.redirect '/', 303
      else
        res.write view('home', title: 'to do list', task: task)
      end
        
    end
  end
end
