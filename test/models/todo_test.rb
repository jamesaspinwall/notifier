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

  test 'tags' do
    todo = Todo.create(todo_attrs)
    assert_empty todo.tags

    assert_on_tags(todo,'a',1)
    assert_on_tags(todo,'a, b',2)
    assert_on_tags(todo,'a, b,c',3)
    assert_on_tags(todo,'a, c',3)
    assert_on_tags(todo,'d, a',4)
    assert_on_tags(todo,'a,d,c',4)
    assert_on_tags(todo,'a, c, , b, d',4)
    assert_on_tags(todo,'c', 4)
    assert_on_tags(todo,'x,y,z',7)
  end

  private

  def assert_on_tags(todo,tag_names,tag_count)
    todo.build_tags(tag_names.clone)
    tag_names = tag_names.split(',').map(&:strip).reject(&:blank?)
    assert_equal tag_names.count, todo.tags.count
    assert_equal tag_names.sort, todo.tags.map(&:name).sort
    assert_equal tag_count, Tag.count
  end
end
