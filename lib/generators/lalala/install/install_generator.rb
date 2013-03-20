require 'rails/generators/active_record'

module Lalala
  module Generators

    # This class is stolen from active admin
    class InstallGenerator < ActiveRecord::Generators::Base

      desc "Installs Active Admin and generates the necessary migrations"
      argument :name, :type => :string, :default => "AdminUser"

      hook_for :users, :default => "devise", :desc => "Admin user generator to run. Skip with --skip-users"

      def self.source_root
        @_active_admin_source_root ||= File.expand_path("../templates", __FILE__)
      end

      def copy_initializer
        @underscored_user_name = name.underscore
        template 'active_admin.rb.erb', 'config/initializers/active_admin.rb'
      end

      def setup_errors
        empty_directory "app/controllers"
        template 'errors_controller.rb', 'app/controllers/errors_controller.rb'
      end

      def setup_pages
        empty_directory "app/models"
        template 'application_page.rb', 'app/models/application_page.rb'
        empty_directory "app/controllers"
        template 'pages_controller.rb', 'app/controllers/pages_controller.rb'
        empty_directory "app/admin"
        template 'admin_pages.rb', 'app/admin/admin_pages.rb'
      end

      def setup_directory
        empty_directory "app/admin"
        template 'dashboard.rb', 'app/admin/dashboard.rb'
        if options[:users].present?
          @user_class = name
          template 'admin_user.rb.erb', "app/admin/#{name.underscore.pluralize}.rb"
        end
      end

      def create_assets
        generate "lalala:assets"
      end

      def create_migrations
        Dir["#{self.class.source_root}/migrations/*.rb"].sort.each do |filepath|
          name = File.basename(filepath)
          migration_template "migrations/#{name}", "db/migrate/#{name.gsub(/^\d+_/,'')}"
          sleep 1
        end
      end

    end
  end
end
