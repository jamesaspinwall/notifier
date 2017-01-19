require 'test_helper'

class TodosControllerTest < ActionDispatch::IntegrationTest

  def setup
    @id = Todo.create(todo_attrs).id
  end

  test "should get index" do
    get todos_url
    assert_response :success

    attrs = Todo.find(@id).attributes.symbolize_keys.extract!(:id, :title)
    attrs.each do |k, v|
      assert_match /#{k}/, response.body
      assert_match /#{v}/, response.body
    end
  end

  test "should get new" do
    get new_todo_url
    assert_response :success
    attrs = Todo.find(@id).attributes.symbolize_keys.extract!(:id, :title)
    attrs.each do |k, v|
      assert_match /#{k}/, response.body
    end
  end

  test "should create todo" do
    assert_difference('Todo.count') do
      post todos_url, params: { todo: todo_attrs }
    end
    id = Rails.application.routes.recognize_path(response.redirect_url)[:id]
    todo = Todo.find(id)
    assert_redirected_to todo_url(todo)
  end

  test "should show todo" do
    get todo_url(@id)
    assert_response :success
    attrs = Todo.find(@id).attributes.symbolize_keys.extract!(:id, :title, :description)
    attrs.each do |k, v|
      assert_match /#{k}/, response.body
      assert_match /#{v}/, response.body
    end
  end

  test "should get edit" do
    get edit_todo_url(@id)
    assert_match /#{@id}/, response.body
    assert_response :success
  end

  test "should update todo" do
    patch todo_url(@id), params: { todo: todo_attrs }
    assert_redirected_to todo_url(@id)
  end

  test "should destroy todo" do
    assert_difference('Todo.count', -1) do
      delete todo_url(@id)
    end
    assert_redirected_to todos_url
  end

  test 'should update only title' do
    @id = Todo.create(todo_attrs).id
    attrs = Todo.find(@id).attributes.symbolize_keys!.extract!(*todo_attrs.keys)
    assert_equal todo_attrs, attrs

    patch todo_url(@id), params: { todo: { title: 'new title' } }
    attrs = Todo.find(@id).attributes.symbolize_keys!.extract!(*todo_attrs.keys)
    assert_equal todo_attrs(title: 'new title'), attrs
  end

  test 'success complete todo' do
    assert_difference 'Todo.active.count', -1 do
      patch todo_url(@id), params: { todo: { complete_at: Time.current } }
    end
  end

  test 'fails when complete_at before created_at' do
    assert_difference 'Todo.active.count', 0 do
      patch todo_url(@id), params: { todo: { complete_at: Time.current - 1.day } }
      #puts response.body
      assert_match /error prohibited this todo from being saved/, response.body
    end
  end

  test 'success started_at' do

  end

  test 'another complete todo' do
    assert_difference 'Todo.active.count', -1 do
      get "/todos/complete/#{@id}"
      refute_empty flash[:error]
    end
  end
end
