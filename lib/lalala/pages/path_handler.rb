module Lalala::Pages::PathHandler
  extend ActiveSupport::Concern

  module ClassMethods

    def ct_scoped_to_path(path, parent_constraint)
      if respond_to?(:translated?) and !translated?(name_sym)
        return super(path, parent_constraint)
      end

      path = path.is_a?(Enumerable) ? path.dup : [path]

      # make scope writable
      scope = scoped.readonly(false)

      # restrict by top
      scope = scope.joins(<<-SQL)
        INNER JOIN #{translations_table_name} AS t_ ON #{quoted_table_name}.id = t_.#{class_name.foreign_key}
      SQL
      scope = scope.where("t_.#{quoted_name_column} = #{ct_quote(path.last)}")


      path[0..-2].reverse.each_with_index do |ea, idx|
        subtable = idx == 0 ? quoted_table_name : "p#{idx - 1}"
        scope = scope.joins(<<-SQL)
          INNER JOIN #{quoted_table_name}       AS p#{idx} ON p#{idx}.id = #{subtable}.#{parent_column_name}
          INNER JOIN #{translations_table_name} AS t#{idx} ON p#{idx}.id = t#{idx}.#{class_name.foreign_key}
        SQL
        scope = scope.where("t#{idx}.#{quoted_name_column} = #{ct_quote(ea)}")
      end


      root_table_name = path.size > 1 ? "p#{path.size - 2}" : quoted_table_name
      scope.where("#{root_table_name}.#{parent_constraint}")
    end

  end
end
