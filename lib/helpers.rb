module Helpers
  def view_home(params = {})
    params[:title] ||= 'to do list'
    params[:list] ||= TaskList.new
    params[:task] ||= Task.new
    res.write view('home', params)
  end
end
