require 'test_helper'

class TodoTest < ActiveSupport::TestCase

  test 'CRUD' do
    id = nil
    attrs = todo_attrs(category_attributes: category_attrs)

    # CREATE
    assert_difference 'Todo.count' do
      Todo.destroy_all
      Category.destroy_all
      Tag.destroy_all
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
    assert todo.category.present?

    assert_difference 'todo.tags.count'  do
      attrs = tag_attrs
      # add a new tag to todo because there is no id in attts
      todo.update(tags_attributes: [attrs])
      assert_equal 4, todo.tags.count
    end

    attrs = todo.tags.last.attributes
    attrs['name'] = 'xxx'
    # just updates the tag because there is id
    todo.update(tags_attributes: [attrs])
    assert_equal 4, todo.tags.count
    assert_equal attrs['name'], Tag.order(:created_at).last.name
  end

  test 'tags' do
    todo = Todo.create(todo_attrs)
    assert_empty todo.tags

    assert_on_tags(todo, 'a', 1)
    assert_on_tags(todo, 'a, b', 2)
    assert_on_tags(todo, 'a, b,c', 3)
    assert_on_tags(todo, 'a, c', 3)
    assert_on_tags(todo, 'd, a', 4)
    assert_on_tags(todo, 'a,d,c', 4)
    assert_on_tags(todo, 'a, c, , b, d', 4)
    assert_on_tags(todo, 'c', 4)
    assert_on_tags(todo, 'x,y,z', 7)
  end

  test 'showable' do
    Todo.create(todo_attrs)
    assert_equal 1, Todo.showable.count
  end

  test 'active' do
    Todo.create(todo_attrs)
    assert_equal 1, Todo.active.count
  end

  test 'create with tag string delimited by comma' do
    %w(a b c d e f g h i j).each do |name|
      Tag.create(name: name)
    end

    data = [
      %W(A a),
      %w(B b),
      %w(C b,c,e),
      %w(D b,c,d,e)
    ]

    assert_difference 'Todo.count', 4 do
      data.each do |title, tag_names_str|
        tags = Tag.by_names(tag_names_str)
        Todo.create(title: title, tags: tags)
      end
    end

    data.each do |title, tag_names_str|
      todo_tags = Todo.find_by(title: title).tags.map(&:name).sort
      tag_names_array = tag_names_str.split(',').map(&:strip).sort
      assert_equal tag_names_array, todo_tags
    end

    todos = Todo.and_tags('a')
    assert_equal ['A'], todos.map(&:title).sort

    todos = Todo.and_tags('b')
    assert_equal ['B', 'C', 'D'], todos.map(&:title).sort

    todos = Todo.and_tags('b,c')
    assert_equal ['C', 'D'], todos.map(&:title).sort

    todos = Todo.and_tags('a,c')
    assert_equal [], todos.map(&:title).sort

    todos = Todo.and_tags('b,d')
    assert_equal ['D'], todos.map(&:title).sort

    todos = Todo.and_tags('z')
    assert_equal [], todos.map(&:title).sort

    todos = Todo.and_tags('b,c,d,e')
    assert_equal ['D'], todos.map(&:title).sort

  end

  test 'create categories delimited by comma' do
    data = %w(a b c d e f g h i j)
    assert_difference 'Category.count', data.size do
      data.each do |name|
        Category.create(name: name)
      end
    end

    data = [
      %W(A a),
      %w(B b),
      %w(C b),
      %w(D a),
      %w(E c),
      %w(F a),
    ]

    assert_difference 'Todo.count', data.size do
      data.each do |title, category_name|
        category = Category.find_by(name: category_name)
        assert Todo.create(title: title, category: category)
      end
    end

    data.each do |title, category_name|
      name = Todo.find_by(title: title).category.name
      assert_equal name, category_name
    end

    todos = Todo.or_categories_by_names('a')
    assert_equal ["A", "D", "F"], todos.map(&:title).sort

    todos = Todo.or_categories_by_names('b')
    assert_equal ["B", "C"], todos.map(&:title).sort

    todos = Todo.or_categories_by_names('a,b')
    assert_equal ["A", "B", "C", "D", "F"], todos.map(&:title).sort

    todos = Todo.or_categories_by_names('a,c')
    assert_equal ["A", "D", "E", "F"], todos.map(&:title).sort

    todos = Todo.or_categories_by_names('b,d')
    assert_equal ["B", "C"], todos.map(&:title).sort

    todos = Todo.or_categories_by_names('z')
    assert_equal [], todos.map(&:title).sort
  end

  private

  def assert_on_tags(todo, tag_names, tag_count)
    todo.build_tags(tag_names.clone)
    tag_names = tag_names.split(',').map(&:strip).reject(&:blank?)
    assert_equal tag_names.count, todo.tags.count
    assert_equal tag_names.sort, todo.tags.map(&:name).sort
    assert_equal tag_count, Tag.count
  end

end
