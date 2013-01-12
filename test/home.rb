require File.expand_path("helper", File.dirname(__FILE__))

scope do
  setup do
    Ohm.flush
    Task.create(title: 'my first task', done: false)
  end

  test 'home' do
    visit '/'
    
    assert has_content?('To do')
    assert has_content?('my first task')
  end

  test 'add a task' do
    visit '/'
    
    fill_in 'task[title]', with: 'my second task'
    click_button 'Add'

    assert has_content?('my second task')
    assert current_path == '/'
  end

  test 'should show error message when try to add an empty task' do
    visit '/'
    fill_in 'task[title]', with: ''
    click_button 'Add'

    assert has_content?('You need to supply a title for the task.')
  end
end
