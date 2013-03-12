module Lalala

  require "lalala/version"

  require 'rails/all'

  groups = Rails.groups(:assets => %w(development test)).map(&:to_sym)


  require 'activeadmin'
  require 'meta_search'
  require 'jquery-rails'
  require 'carrierwave'
  require 'mini_magick'
  require 'closure_tree'
  require 'active_admin-awesome_nested_set'

  if groups.include?(:assets)
    require 'sass'
    require 'sass-rails'
    require 'compass-rails'

    require 'coffee_script/source'
    require 'coffee-rails'
    require 'sprockets/commonjs'

    require 'uglifier'
  end

  require 'lalala/engine'

end
