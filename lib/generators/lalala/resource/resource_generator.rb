require 'rails/generators/rails/model/model_generator'

module Lalala
  module Generators
    class ResourceGenerator < Rails::Generators::ModelGenerator
      desc "Create a new resource"

      def create_aa_resource
        invoke "active_admin:resource", [name]
      end

    end
  end
end
