require 'test_helper'

class IAmTest < ActiveSupport::TestCase
  test 'I am' do
    i_am = IAm.new
    assert i_am.yes
  end
end
