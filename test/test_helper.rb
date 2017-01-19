ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/rails/capybara"

require "minitest/reporters"
Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new, Minitest::Reporters::JUnitReporter.new]

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #fixtures :all
  # Add more helper methods to be used by all tests here...
end

Dir[Rails.root.join("test/support/**/*.rb")].each { |f| require f }

module Minitest
  class Test
    include Attrs
    #include Attrs::Person
  end
end

# module ActionDispatch
#   class IntegrationTest
#     include Attrs
#   end
# end
#
