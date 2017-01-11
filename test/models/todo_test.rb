require 'test_helper'

class TodoTest < ActiveSupport::TestCase
  test 'CRUD' do
    todo = nil

    assert_difference 'Todo.count' do
      todo = Todo.create(Attrs.todo(context_attributes: Attrs.context))
    end

    assert_equal todo, Todo.find(todo.id)

    todo.update(title: 'xxx')
    assert_equal 'xxx', Todo.find(todo.id).title

    assert_difference 'Todo.count', -1 do
      todo.destroy
    end
  end

  test 'append tag to todo' do
    t = Todo.create(Attrs.todo(context_attributes: Attrs.context))
    puts t.errors.messages if t.errors.present?

    t.tags << Tag.create(Attrs.tag)
    t.save
    assert_equal 1, Todo.last.tags.count
  end

  test 'accepts_nested_attributes_for tags an context' do
    assert_difference 'Todo.count' do
      Todo.create(
        Attrs.todo(
          tags_attributes: [Attrs.tag, Attrs.tag, Attrs.tag],
          context_attributes: Attrs.context
        )
      ).is_a?(Todo)
    end

    todo = Todo.first
    assert_equal 3, todo.tags.count
    refute_nil todo.category

    tag_attrs = Attrs.tag
    todo.update(tags_attributes: [tag_attrs])
    assert_equal 4, todo.tags.count

    tag_attrs = todo.tags.last.attributes
    tag_attrs[:name] = 'xxx'
    todo.update(tags_attributes: [tag_attrs])
    assert_equal 4, todo.tags.count


  end

end
