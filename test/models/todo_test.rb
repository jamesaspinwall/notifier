require 'test_helper'

class TodoTest < ActiveSupport::TestCase

  test 'CRUD' do
    id = nil
    attrs = todo_attrs(category_attributes: category_attrs)

    # CREATE
    assert_difference 'Todo.count' do
      id = Todo.create(attrs).id
    end

    # RETRIEVE
    todo = Todo.find(id)
    attrs.each do |k, v|
      unless k.to_s =~ /(.*)_attributes$/
        assert_equal v, todo[k]
      else
        v.each do |k, v|
          assert_equal v, todo.send($1)[k]
        end
      end
    end

    # UPDATE
    Todo.find(id).update(title: 'xxx')
    assert_equal 'xxx', Todo.find(id).title

    # DESTROY
    assert_difference 'Todo.count', -1 do
      Todo.find(id).destroy
    end
  end

  test 'append tag to todo' do
    assert_difference 'Todo.count' do
      todo = Todo.create todo_attrs(category_attributes: category_attrs, tags_attributes: [tag_attrs])
      assert_equal 1, todo.tags.count
    end
  end

  test 'accepts_nested_attributes_for tags an category' do
    assert_difference 'Todo.count' do
      Todo.create(
        todo_attrs(
          tags_attributes: [tag_attrs, tag_attrs, tag_attrs],
          category_attributes: category_attrs
        )
      )
    end

    todo = Todo.first
    assert_equal 3, todo.tags.count
    refute_nil todo.category

    assert_difference 'todo.tags.count' do
      todo.update(tags_attributes: [tag_attrs])
      assert_equal 4, todo.tags.count
    end

    attrs = todo.tags.last.attributes
    attrs[:name] = 'xxx'
    todo.update(tags_attributes: [attrs])
    assert_equal 4, todo.tags.count
    assert_equal attrs[:name], Tag.order(:updated_at).last.name
  end

end
