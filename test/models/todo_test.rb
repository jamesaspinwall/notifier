require 'test_helper'

class TodoTest < ActiveSupport::TestCase
  test 'CRUD' do
    todo = nil

    assert_difference 'Todo.count' do
      todo = Todo.create(Attrs.todo)
    end

    assert_equal todo, Todo.find(todo.id)

    todo.update(title: 'xxx')
    assert_equal 'xxx', Todo.find(todo.id).title

    assert_difference 'Todo.count', -1 do
      todo.destroy
    end
  end
end
