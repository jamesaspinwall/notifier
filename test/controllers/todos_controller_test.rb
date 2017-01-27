require 'test_helper'

class TodosControllerTest < ActionDispatch::IntegrationTest
  #include Devise::Test::ControllerHelpers

  def setup
    @user = User.new(:email => 'test@example.com', :password => 'password', :password_confirmation => 'password')
    @user.save
    sign_in @user
  end

  test "should get index" do
    @id = Todo.create(todo_attrs(user:@user)).id

    get todos_url
    assert_response :success

    attrs = Todo.find(@id).attributes.symbolize_keys.extract!(:id, :title)
    attrs.each do |k, v|
      assert_match /#{k}/, response.body
      assert_match /#{v}/, response.body
    end
  end

  test "should get new" do
    @id = Todo.create(todo_attrs(user:@user)).id

    get new_todo_url
    assert_response :success
    attrs = Todo.find(@id).attributes.symbolize_keys.extract!(:id, :title)
    attrs.each do |k, v|
      assert_match /#{k}/, response.body
    end
  end

  test "should create todo" do
    assert_difference('Todo.count') do
      post todos_url, params: {todo: todo_attrs(user:@user)}
    end
    #id = Rails.application.routes.recognize_path(response.redirect_url)[:id]
    #todo = Todo.find(id)
    assert_redirected_to todos_url
  end

  test "should show todo" do
    @id = Todo.create(todo_attrs(user:@user)).id

    get todo_url(@id)
    assert_response :success
    attrs = Todo.find(@id).attributes.symbolize_keys.extract!(:id, :title, :description)
    attrs.each do |k, v|
      assert_match /#{k}/, response.body
      assert_match /#{v}/, response.body
    end
  end

  test "should get edit" do
    @id = Todo.create(todo_attrs(user:@user)).id

    get edit_todo_url(@id)
    assert_match /#{@id}/, response.body
    assert_response :success
  end

  test "should update todo" do
    @id = Todo.create(todo_attrs(user:@user)).id

    attrs = todo_attrs
    patch todo_url(@id), params: {todo: attrs}
    assert_redirected_to todos_url
    assert_equal attrs[:title], Todo.find(@id).title
  end

  test "should destroy todo" do
    @id = Todo.create(todo_attrs(user:@user)).id

    assert_difference('Todo.count', -1) do
      delete todo_url(@id)
    end
    assert_redirected_to todos_url
  end

  test 'should update only title' do
    @id = Todo.create(todo_attrs(user:@user)).id

    attrs = Todo.find(@id).attributes.symbolize_keys!.extract!(*todo_attrs.keys)
    assert_equal todo_attrs, attrs

    patch todo_url(@id), params: {todo: {title: 'new title'}}
    attrs = Todo.find(@id).attributes.symbolize_keys!.extract!(*todo_attrs.keys)
    assert_equal todo_attrs(title: 'new title'), attrs
  end

  test 'success complete todo' do
    @id = Todo.create(todo_attrs(user:@user)).id

    assert_difference 'Todo.completed_at(nil).count', -1 do
      patch todo_url(@id), params: {todo: {completed_at: Time.current}}
      assert_response :redirect
    end
  end

  test 'fails when completed_at before created_at' do
    @id = Todo.create(todo_attrs(user:@user)).id

    assert_difference 'Todo.completed_at(nil).count', -1 do
      completed_at = Time.current
      patch todo_url(@id), params: {todo: {completed_at: completed_at}}
      assert_equal completed_at.to_i, assigns(:todo).completed_at.to_i
    end
  end

  test 'index with categories' do

    create_todos

    get todos_url params: {or_categories: 'a,b'}
    assert_equal ['A', 'B'], assigns(:todos).map(&:title)

    get todos_url params: {or_categories: 'c'}
    assert_equal ['C'], assigns(:todos).map(&:title)

    get todos_url params: {or_categories: nil}
    assert_equal ['A', 'B', 'C'], assigns(:todos).map(&:title)

  end

  test 'index with tags' do

    create_todos

    get todos_url, params: {and_tags: 'x'}
    assert_equal ['A', 'B'], assigns(:todos).map(&:title)

    get todos_url, params: {and_tags: 'y'}
    assert_equal ['A', 'C'], assigns(:todos).map(&:title)

    get todos_url, params: {and_tags: 'z'}
    assert_equal ['C'], assigns(:todos).map(&:title)

    get todos_url, params: {and_tags: nil}
    assert_equal ['A', 'B', 'C'], assigns(:todos).map(&:title)
  end

  test 'index with categories and tags' do

    create_todos

    get todos_url, params: {and_tags: 'x'}
    assert_equal ['A', 'B'], assigns(:todos).map(&:title)

    get todos_url, params: {and_tags: 'y'}
    assert_equal ['A', 'C'], assigns(:todos).map(&:title)

    get todos_url, params: {and_tags: 'z'}
    assert_equal ['C'], assigns(:todos).map(&:title)

    get todos_url, params: {and_tags: nil}
    assert_equal ['A', 'B', 'C'], assigns(:todos).map(&:title)
  end

  test 'index with completed range' do

    create_todos_for_completed
    get todos_url, params: {completed_at: 'yesterday at 1 am,now'}
    assert_equal ['A', 'D'], assigns(:todos).map(&:title)

  end

  test 'invalid with with completed range bad format' do

    create_todos_for_completed
    get todos_url, params: {completed_at: 'yesterday at 1 am, nowi'}
    assert_equal Todo.count, assigns(:todos).count
    refute_empty flash[:error]

  end

  test 'another complete todo' do
    skip
    @id = Todo.create(todo_attrs(user: @user)).id

    assert_difference 'Todo.active.count', -1 do
      get "/todos/complete/#{@id}"
      refute_empty flash[:error]
    end

  end

  test 'index with show_at range' do

    create_todos_for_show_at
    get todos_url, params: {show_at: 'tomorrow 11:59PM'}
    assert_equal ['A', 'B','D'], assigns(:todos).map(&:title).sort

  end

  test 'index with show_at blank' do

    create_todos_for_show_at
    get todos_url, params: {show_at: ''}
    assert_equal ['B','D'], assigns(:todos).map(&:title)

  end

  private

  def create_todos
    
    Category.destroy_all
    Tag.destroy_all

    [
      ['A', 'a', ['x', 'y']],
      ['B', 'b', ['x']],
      ['C', 'c', ['y', 'z']]
    ].each do |title, category, tag_names|
      tags = tag_names.map do |t|
        Tag.find_or_create_by(name: t)
      end
      todo = Todo.new(todo_attrs(user:@user, title: title, category_attributes: {name: category},))
      todo.tags = tags
      todo.save
    end
  end

  def create_todos_for_completed
    
    data = [
      ['A', Time.current-1.day],
      ['B', nil],
      ['C', Time.current-2.days],
      ['D', Time.current-2.minutes],
      ['E', Time.current - 7.days]

    ]

    data.each do |title, completed_at|
      Todo.create(todo_attrs(user:@user, title: title, completed_at: completed_at))
    end
    assert_equal data.size, Todo.count
  end

  def create_todos_for_show_at
    data = [
      ['A', Time.current + 1.hours],
      ['B', nil],
      ['C', Time.current + 2.days],
      ['D', Time.current - 2.minutes],
      ['E', Time.current + 7.days]

    ]

    data.each do |title, show_at|
      Todo.create(todo_attrs(user:@user, title: title, show_at: show_at))
    end
    assert_equal data.size, Todo.count

  end

end
