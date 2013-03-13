class Lalala::Engine < Rails::Engine

  initializer "lalala.active_admin.load_path" do
    ActiveAdmin.application.load_paths.unshift File.expand_path('../admin', __FILE__)
  end

  ::Sass::Engine::DEFAULT_OPTIONS[:load_paths] << File.expand_path("../../../app/assets/stylesheets", __FILE__)

end
