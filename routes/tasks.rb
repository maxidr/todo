class Tasks < Cuba
  define do

    # Create a task
    on post, param('task') do |params|
      task = Task.new(params)
      
      if task.save
        res.redirect '/', 303
      else
        view_home(task: task)
      end
    end

    # Update a task
    on put, ':id', param('task') do |id, params|
      task = Task[id]
      task.update(params)
      res.redirect '/', 303
    end

  end
end
