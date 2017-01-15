require 'test_helper'

class TagTest < ActiveSupport::TestCase
  test 'CRUD' do
    Tag.create(tag_attrs)
  end
end
