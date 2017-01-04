require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Notifier
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.time_zone = 'UTC'
    config.active_record.time_zone_aware_types = [:datetime, :time]

    config.autoload_paths +=[ "#{config.root}/app/validators/","#{config.root}/app/models/types/"]

  end
end
