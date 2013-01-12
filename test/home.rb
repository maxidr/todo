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
    
    fill_in 'title', with: 'my second task'
    click_button 'Add'

    assert has_content?('my second task')
    assert current_path == '/'
  end
end
