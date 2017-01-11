require 'test_helper'

class ContextsControllerTest < ActionDispatch::IntegrationTest
  setup do
    category = contexts(:one)
  end

  test "should get index" do
    get contexts_url
    assert_response :success
  end

  test "should get new" do
    get new_context_url
    assert_response :success
  end

  test "should create context" do
    assert_difference('Context.count') do
      post contexts_url, params: {category: {name: category.name } }
    end

    assert_redirected_to context_url(Category.last)
  end

  test "should show context" do
    get context_url(category)
    assert_response :success
  end

  test "should get edit" do
    get edit_context_url(category)
    assert_response :success
  end

  test "should update context" do
    patch context_url(category), params: {category: {name: category.name } }
    assert_redirected_to context_url(category)
  end

  test "should destroy context" do
    assert_difference('Context.count', -1) do
      delete context_url(category)
    end

    assert_redirected_to contexts_url
  end
end
