module Lalala

  require "lalala/version"

  require 'rails/all'

  groups = Rails.groups(:assets => %w(development test)).map(&:to_sym)

  require 'globalize3'
  require 'activeadmin'
  require 'meta_search'
  require 'jquery-rails'
  require 'carrierwave'
  require 'mini_magick'
  require 'closure_tree'
  require 'redcarpet'

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

  require 'lalala/views/tree_table_for'
  require 'lalala/views/index_as_tree_table'
  require 'lalala/markdown'

  module Core
    require 'lalala/core/class_inheritable_setting'
  end

  module Pages
    require 'lalala/pages/child_type_validator'
  end

end
