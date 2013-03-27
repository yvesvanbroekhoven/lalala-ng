class AppBuilder < Rails::AppBuilder
  include Thor::Actions
  include Thor::Shell

  RUBY_VERSION = "1.9.2"

  def gemfile
    create_file 'Gemfile', <<-DOC
source 'https://rubygems.org'

ruby "1.9.3"

gem 'lalala', :github => 'mrhenry/lalala-ng', :submodules => true

group :development do
  gem 'sqlite3'
end
DOC
  end

  def ruby_version
    create_file ".ruby-version", RUBY_VERSION
  end

  def leftovers
    ruby_version
  end

end

class Rails::Generators::AppGenerator

  alias_method :lng_run_bundle, :run_bundle

  def run_bundle
    lng_run_bundle
    generate "lalala:install"
  end

end
