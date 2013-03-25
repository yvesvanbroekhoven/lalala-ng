require 'rails/generators/rails/model/model_generator'

module Lalala
  module Generators
    class ResourceGenerator < Rails::Generators::NamedBase
      desc "Create a new page model"

      def self.source_root
        @_active_admin_source_root ||= File.expand_path("../templates", __FILE__)
      end

      def generate_config_file
        template "page.rb", "app/models/#{file_path}.rb"
      end

    end
  end
end
