module Lalala
  module Test
    extend ActiveSupport::Autoload

    autoload :LoginHelper

    def self.setup!
      require 'capybara/rails'
      require 'capybara/poltergeist'

      Rails.backtrace_cleaner.remove_silencers!

      ActionDispatch::IntegrationTest.send :include, Lalala::Test::LoginHelper
      ActionDispatch::IntegrationTest.send :include, Capybara::DSL

      Capybara.javascript_driver = :poltergeist

      I18n.reload!
    end

  end
end
