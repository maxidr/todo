require File.expand_path("helper", File.dirname(__FILE__))

setup do 
  Ohm.flush
end

scope do
  setup do
    list = TaskList.create(name: 'My list')
    task = Task.create(title: 'my first task', done: false, on_list: list)
  end

  test 'home' do
    visit '/'
   
    assert has_content?('My list')
    assert has_content?('my first task')
  end

  test 'add a list' do
    visit '/'
    fill_in 'list[name]', with: 'new list on the block :P'
    click_button 'add_list'

    assert has_content? 'new list on the block :P'
    assert current_path == '/'
  end

  test 'should show error when try to add a list with empty name' do
    visit '/'
    fill_in 'list[name]', with: ''
    click_button 'add_list'

    assert has_content?('You need to supply a name for the list.')
  end

  test 'add a task' do
    visit '/'
    
    fill_in 'task[title]', with: 'my second task'
    select 'My list', from: 'task[on_list_id]'
    click_button 'add_task'

    assert has_content?('my second task')
    assert current_path == '/'
  end

  test 'should show error message when try to add an empty task' do
    visit '/'
    fill_in 'task[title]', with: ''
    click_button 'add_task'

    assert has_content?('You need to supply a title for the task.')
  end

  test 'done task' do
    visit '/'
    find('li', text: 'my first task').find('button').click()
    assert !has_content?('my first task')
  end
    
end
