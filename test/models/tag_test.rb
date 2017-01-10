require 'test_helper'

class TagTest < ActiveSupport::TestCase
  test 'CRUD' do
    Tag.create(Attrs.tag)
  end
end
