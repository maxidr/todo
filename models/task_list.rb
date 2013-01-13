class TaskList < Ohm::Model
  attribute :name
  list :tasks, :Task

  def validate 
    assert_present :name
  end

  def tasks_to_complete
    Task.find(done: false, on_list_id: id)
  end
end
