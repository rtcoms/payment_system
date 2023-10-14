require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PaymentSystem
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    config.eager_load_paths << Rails.root.join("app/controllers/concerns")

    # Don't generate system test files.
    config.generators.system_tests = nil
    config.active_job.queue_adapter = :good_job
    ActiveJob::Base.queue_adapter = :good_job

    config.good_job.enable_cron = true
    config.good_job.cron = {
      transaction_cleaner_schedule: {
        cron: "0 * * * *",
        class: "TransactionCleanerJob"
      }
    }

    api_settings = YAML.load_file(Rails.root.join('config', 'api_config.yml'))

    config.api_settings = api_settings
  end
end
