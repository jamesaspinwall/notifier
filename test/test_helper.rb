ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

def notice_attr(attr = {})
  {
    title: 'title',
    description: 'description',
    notify_chronic: 'tomorrow 11 AM',
  }.merge attr
end
