class Lalala::Engine < Rails::Engine

  initializer "lalala.assest.load_path", :group => :all do
    ::Sass::Engine::DEFAULT_OPTIONS[:load_paths] << File.expand_path("../../../app/assets/stylesheets", __FILE__)
  end

end
