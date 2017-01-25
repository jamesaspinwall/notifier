require 'test_helper'

class TodoFlowTest < Capybara::Rails::TestCase

  test 'ISNECUD' do
    Todo.create(todo_attrs)
    visit todos_path(for_user: '')
    assert page.has_content? 'title field'
    assert true
  end
end