require 'test_helper'

class TagTest < ActiveSupport::TestCase
  test 'CRUD' do
    Tag.create(tag_attrs)
  end

  test 'by_names' do
    %w(a x y z p q r).each do |name|
      Tag.create(name: name)
    end

    ['', 'x,y','z,p, q'].each do |names|
      tags = Tag.by_names(names)
      tag_names = names.split(',').map(&:strip)
      assert_equal tag_names.size , tags.count
      assert_equal tag_names.sort, tags.map(&:name).sort
    end
  end
end
