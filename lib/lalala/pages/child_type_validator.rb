class Lalala::Pages::ChildTypeValidator < ActiveModel::Validator

  def validate(record)
    types = normalize_types(options[:types], record)

    record.children.each do |child|
      valid = types.any? do |type|
        child.is_a?(type)
      end

      unless valid
        record.errors.add :base, "Invalid child type: #{child.class.to_s.humanize}"
      end
    end
  end

private

  def normalize_types(types, record)
    if Proc === types
      types = types.call(record)
    end

    if types.nil?
      types = []
    end

    unless Array === types
      raise ArgumentError, "ChildTypeValidator expected a list of class names for :types."
    end

    types = types.map do |type|
      if Class === type
        type
      else
        type.to_s.classify.constantize
      end
    end

    types
  end

end
