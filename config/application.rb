require_relative "boot"

require "rails/all"
require "dotenv/load"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Neighborhood
  class Application < Rails::Application
    config.api_only = true

    config.load_defaults 7.0

    config.middleware.use Rack::Cors do
      allow do
        origins '*'
        resource '*',
          headers: :any,
          expose: ['access-token', 'expiry', 'token-type', 'uid', 'client'],
          methods: [:get, :post, :options, :delete, :put]
      end
    end

    # TODO: At the moment it is not critical, but in the future you should switch to Redis
    config.middleware.use ActionDispatch::Session::CookieStore, key: '_session', expire_after: 1.hour
  end
end
