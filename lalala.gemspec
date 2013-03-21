# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lalala/version'

Gem::Specification.new do |gem|
  gem.name          = "lalala"
  gem.version       = Lalala::VERSION

  gem.authors       = [
    "Simon Menke",
    "Yves Van Broekhoven",
    "Steven Vandevelde",
    "Hans Spooren",
    "Inge Reulens",
    "Simon Pertz"
  ]

  gem.email         = ["hello@mrhenry.be"]
  gem.description   = %q{Lalala: Probably the best CMS in the world}
  gem.summary       = %q{Lalala: Probably the best CMS in the world.}
  gem.homepage      = "http://mrhenry.be"

  gem.files = `git ls-files`.split($/).reject{ |f| /^vendor\/deps/ === f }
  gem.files += `cd vendor/deps/active_admin ; git ls-files`.split($/).map { |f| "vendor/deps/active_admin/#{f}" }
  gem.files += `cd vendor/deps/closure_tree ; git ls-files`.split($/).map { |f| "vendor/deps/closure_tree/#{f}" }

  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]


  # generic
  gem.add_runtime_dependency 'carrierwave',  '= 0.8.0'
  gem.add_runtime_dependency 'globalize3',   '= 0.3.0'
  gem.add_runtime_dependency 'jquery-rails', '= 2.2.1'
  gem.add_runtime_dependency 'meta_search',  '= 1.1.3'
  gem.add_runtime_dependency 'mini_magick',  '= 3.5.0'
  gem.add_runtime_dependency 'pg',           '= 0.14.1'
  gem.add_runtime_dependency 'rails',        '= 3.2.13'
  gem.add_runtime_dependency 'redcarpet',    '= 2.2.2'
  gem.add_runtime_dependency 'thin',         '= 1.5.1'
  gem.add_runtime_dependency 'stringex',     '= 1.5.1'


  # assets group
  gem.add_runtime_dependency 'coffee-rails',         '= 3.2.2'
  gem.add_runtime_dependency 'coffee-script-source', '= 1.4.0'
  gem.add_runtime_dependency 'compass',              '= 0.13.alpha.0'
  gem.add_runtime_dependency 'compass-rails',        '= 1.0.3'
  gem.add_runtime_dependency 'sass',                 '= 3.2.7'
  gem.add_runtime_dependency 'sass-rails',           '= 3.2.6'
  gem.add_runtime_dependency 'sprockets-commonjs',   '= 0.0.5'
  gem.add_runtime_dependency 'uglifier',             '= 1.3.0'

  # vendor/deps/active_admin
  # gem.add_runtime_dependency 'activeadmin',  '= 0.5.1'
  gem.add_runtime_dependency "arbre",               ">= 1.0.1"
  gem.add_runtime_dependency "bourbon",             ">= 1.0.0"
  gem.add_runtime_dependency "devise",              ">= 1.1.2"
  gem.add_runtime_dependency "fastercsv",           ">= 0"
  gem.add_runtime_dependency "formtastic",          ">= 2.0.0"
  gem.add_runtime_dependency "inherited_resources", ">= 1.3.1"
  gem.add_runtime_dependency "kaminari",            ">= 0.13.0"
  gem.add_runtime_dependency "meta_search",         ">= 0.9.2"

  # vendor/deps/closure_tree
  # gem.add_runtime_dependency 'closure_tree', '= 3.10.0'
  gem.add_runtime_dependency 'with_advisory_lock',   '>= 0.0.6'

end