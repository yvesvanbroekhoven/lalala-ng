module Lalala::Core::ClassInheritableSetting

  extend ActiveSupport::Concern

  module ClassMethods
    def define_setting(name, options={})
      class_eval <<-RUBY, __FILE__, __LINE__ + 1

        class << self
          attr_writer #{name.inspect}
        end

        def self.#{name}
          if defined?(@#{name})
            @#{name}
          else
            super
          end
        end

        def #{name}
          if defined?(@#{name})
            @#{name}
          else
            self.class.#{name}
          end
        end

      RUBY

      instance_variable_set("@#{name}", options[:default])
    end
  end

end
