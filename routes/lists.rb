class Lists < Cuba
  define do
    
    # Create a list of tasks
    on post, param('list') do |params|
      list = TaskList.new(params)
      if list.save
        res.redirect '/', 303
      else
        view_home(list: list)
      end
    end

  end
end
