require 'test_helper'

class ContextTest < ActiveSupport::TestCase
  test 'CRUD' do
    context = nil

    assert_difference 'Context.count' do
      context = Context.create(Attrs.context)
    end

    assert_equal context, Context.find(context.id)

    context.update(name: 'xxx')
    assert_equal 'xxx', Context.find(context.id).name

    assert_difference 'Context.count', -1 do
      context.destroy
    end

  end
end
