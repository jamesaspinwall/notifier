require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Notifier
  class Application < Rails::Application
    # Use the responders controller from the responders gem
    config.app_generators.scaffold_controller :responders_controller

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.time_zone = 'UTC'
    config.active_record.time_zone_aware_types = [:datetime, :time]

    config.autoload_paths +=[
      "#{config.root}/app/validators/",
      "#{config.root}/app/models/types/",
      "#{config.root}/app/services/",
      "#{config.root}/lib/"
    ]

    config.autoload_paths += [
      "#{config.root}/test/support/",
    ] if %w(development test).include? Rails.env
    #config.autoload_paths << "#{Rails.root}/services"
    config.time_zone = 'UTC'

  end
end
