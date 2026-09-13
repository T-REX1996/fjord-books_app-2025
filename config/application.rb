require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, some gems may be limited to specific
# environments and won't be required in that environment. Call
# bundle exec rake gems:specifications:json to see which gems are in your
# current environment.
# Require gems from Gemfile, respecting Gemfile and gems sections
# :git, :branch, :platforms, :require, and :group options are supported
Bundler.require(*Rails.groups)

module BooksApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # i18n configuration
    config.i18n.default_locale = :ja
    config.i18n.available_locales = [:en, :ja]
  end
end
