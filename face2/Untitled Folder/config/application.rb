require File.expand_path('../boot', __FILE__)

require "rails/all"
require "active_model/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"

CONFIG = YAML.load(File.read(File.expand_path("../secrets.yml", __FILE__)))
CONFIG.merge! CONFIG.fetch(Rails.env, {})
CONFIG.symbolize_keys!

Bundler.require(*Rails.groups)

module CosplayServer
  class Application < Rails::Application
    config.autoload_paths += %W(#{config.root}/lib)
    config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)
    config.assets.paths << Rails.root.join("vendor", "assets", "images")
    config.i18n.default_locale = :ja
    config.time_zone = "Singapore"
    config.action_controller
      .page_cache_directory = "#{Rails.root}/#{Settings.page_cache_directory}"

    config.generators do |g|
      g.orm :active_record
    end
  end
end

ActionView::Base.sanitized_allowed_tags.merge(%w(iframe))
ActionView::Base.sanitized_allowed_attributes.merge(%w(id))
