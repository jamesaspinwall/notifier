require 'test_helper'

class TodoTest < ActiveSupport::TestCase

  test 'abc' do
    puts person_attrs
  end

  test 'CRUD' do
    todo = nil
    attrs = todo_attrs(category_attributes: category_attrs)

    # CREATE
    assert_difference 'Todo.count' do
      Todo.create(attrs)
    end

    # RETRIEVE
    todo = Todo.last
    attrs.each do |k, v|
      if k.to_s =~ /(.*)_attributes$/
        v.each{|k,v|
          assert_equal v,todo.send($1)[k]
        }
      else
        assert_equal v, todo[k]
      end
    end

    # UPDATE
    todo.update(title: 'xxx')
    assert_equal 'xxx', Todo.find(todo.id).title
    # DESTROY
    assert_difference 'Todo.count', -1 do
      todo.destroy
    end
  end

  test 'append tag to todo' do
    t = Todo.create(Attrs.todo(context_attributes: Attrs.category))
    puts t.errors.messages if t.errors.present?

    t.tags << Tag.create(Attrs.tag)
    t.save
    assert_equal 1, Todo.last.tags.count
  end

  test 'accepts_nested_attributes_for tags an category' do
    assert_difference 'Todo.count' do
      Todo.create(
        Attrs.todo(
          tags_attributes: [Attrs.tag, Attrs.tag, Attrs.tag],
          context_attributes: Attrs.category
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
