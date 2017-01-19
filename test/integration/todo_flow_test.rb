require 'test_helper'

class TodoFlowTest < Capybara::Rails::TestCase

  test 'ISNECUD' do
    Todo.create(todo_attrs)
    visit todos_path
    assert page.has_content? 'title field'
    assert page.has_content? 'Just description'
    assert true
  end
end