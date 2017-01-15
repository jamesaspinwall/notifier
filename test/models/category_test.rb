require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  test 'CRUD' do
    category = nil

    assert_difference 'Category.count' do
      category = Category.create(category)
    end

    assert_equal category, Category.find(category.id)

    category.update(name: 'xxx')
    assert_equal 'xxx', Category.find(category.id).name

    assert_difference 'Category.count', -1 do
      category.destroy
    end

  end
end
