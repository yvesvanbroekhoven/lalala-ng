module Lalala::ActiveRecord::Schema::JoinTableInverter
  extend ActiveSupport::Concern

  def invert_create_join_table(*args)
    [:drop_join_table, args]
  end

end
