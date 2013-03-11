module Lalala

  require "lalala/version"

  require 'rails/all'

  groups = Rails.groups(:assets => %w(development test)).map(&:to_sym)

  require 'activeadmin'
  require 'meta_search'
  require 'jquery-rails'

  if groups.include?(:assets)
    require 'sass'
    require 'sass-rails'
    require 'compass-rails'

    require 'coffee-script/source'
    require 'coffee-rails'

    require 'uglifier'
  end

  require 'lalala/engine'

end
