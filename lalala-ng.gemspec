# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lalala/version'

Gem::Specification.new do |gem|
  gem.name          = "lalala-ng"
  gem.version       = Lalala::VERSION
  gem.authors       = ["Simon Menke"]
  gem.email         = ["simon.menke@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  # generic
  gem.add_runtime_dependency 'rails',       '3.2.12'
  gem.add_runtime_dependency 'activeadmin', '0.5.1'
  gem.add_runtime_dependency 'meta_search', '>= 1.1.0.pre'
  gem.add_runtime_dependency 'carrierwave', '~> 0.8'
  gem.add_runtime_dependency 'mini_magick', '~> 3.5'
  gem.add_runtime_dependency 'jquery-rails'

  # assets group
  gem.add_runtime_dependency 'sass-rails',           '~> 3.2.3'
  gem.add_runtime_dependency 'sass',                 '=  3.2.7'
  gem.add_runtime_dependency 'compass-rails',        '~> 1.0'
  gem.add_runtime_dependency 'compass',              '= 0.13.alpha.0'
  gem.add_runtime_dependency 'coffee-rails',         '~> 3.2.1'
  gem.add_runtime_dependency 'coffee-script-source', '~> 1.4.0'
  gem.add_runtime_dependency 'uglifier',             '>= 1.0.3'

end
