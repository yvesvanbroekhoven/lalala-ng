module Lalala
  module Generators
    class PageGenerator < Rails::Generators::NamedBase
      desc "Create a new page model"

      def self.source_root
        @_active_admin_source_root ||= File.expand_path("../templates", __FILE__)
      end

      def generate_config_file
        empty_directory 'app/pages'
        template "page.rb", "app/pages/#{file_path}.rb"
      end

    end
  end
end
