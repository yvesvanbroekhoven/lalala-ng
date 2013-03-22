class Lalala::Engine < Rails::Engine

  config.i18n.fallbacks = true
  config.i18n.default_locale = :en
  config.i18n.available_locales = [:en]

  initializer "lalala.error_handlers" do |app|
    app.config.exceptions_app = app.routes
  end

  initializer "lalala.active_admin.load_path" do
    ActiveAdmin.application.load_paths.unshift File.expand_path('../admin', __FILE__)
  end

  ::Sass::Engine::DEFAULT_OPTIONS[:load_paths] << File.expand_path("../../../app/assets/stylesheets", __FILE__)

end

if defined?(Rails::Generators)
  Rails::Generators.hidden_namespaces << %w(
    active_admin:resource
    active_admin:install
    responders:install
    paper_trail:install
    mongoid:devise
    lalala:devise
    lalala:assets
    kaminari:config
    kaminari:views
    js:assets
    jquery:install
    formtastic:form
    formtastic:install
    devise
    devise:install
    devise:views
    coffee:assets
    active_admin:assets
    active_admin:devise
    active_admin:install
    active_admin:resource
    active_record:devise
    test_unit:controller
    test_unit:helper
    test_unit:integration
    test_unit:mailer
    test_unit:model
    test_unit:observer
    test_unit:performance
    test_unit:plugin
    test_unit:scaffold
    scss:assets
    scss:scaffold
    active_record:migration
    active_record:model
    active_record:observer
    active_record:session_migration
  )

  Rails::Generators.hidden_namespaces.flatten!
end
