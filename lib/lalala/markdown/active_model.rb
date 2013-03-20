module Lalala::Markdown::ActiveModel
  extend ActiveSupport::Concern

  module ClassMethods

    def markdown(*columns)
      options = columns.extract_options!
      @markdown_transformers ||= {}

      md  = Lalala::Markdown.new(options)
      mod = Module.new

      columns.each do |column|
        column = column.to_sym

        @markdown_transformers[column] = md

        mod.class_eval <<-SRC, __FILE__, __LINE__ + 1

          def #{column}_html
            value = self.#{column} || ""
            value = self.class.markdown_transformer_for_column(#{column.inspect}).render(value)
            value.html_safe
          end

          def #{column}=(value)
            value = self.class.markdown_transformer_for_column(#{column.inspect}).format(value)
            super(value)
          end

        SRC
      end

      include(mod)
    end

    def markdown_transformer_for_column(column_name)
      if @markdown_transformers and @markdown_transformers.key?(column_name)
        return @markdown_transformers[column_name]
      end

      if superclass.respond_to?(:markdown_transformer_for_column)
        return superclass.markdown_transformer_for_column(column_name)
      end

      raise "Missing markdown transformer for column `#{column_name}`"
    end

  end

end
