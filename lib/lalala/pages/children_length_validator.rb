class Lalala::Pages::ChildrenLengthValidator < ActiveModel::Validations::LengthValidator

  def check_validity!
    keys = CHECKS.keys & options.keys

    if keys.empty?
      raise ArgumentError, 'Range unspecified. Specify the :in, :within, :maximum, :minimum, or :is option.'
    end

    keys.each do |key|
      value = options[key]

      if value.is_a?(Proc)
        next
      end

      if value.is_a?(Integer) && value >= 0
        next
      end

      raise ArgumentError, ":#{key} must be a nonnegative Integer"
    end
  end

  def validate_each(record, attribute, value)
    value = tokenize(value)
    value_length = value.respond_to?(:length) ? value.length : value.to_s.length

    CHECKS.each do |key, validity_check|
      check_value = options[key]
      check_value = check_value.call(record) if Proc === check_value
      next unless check_value
      next if value_length.send(validity_check, check_value)

      errors_options = options.except(*RESERVED_OPTIONS)
      errors_options[:count] = check_value

      default_message = options[MESSAGES[key]]
      errors_options[:message] ||= default_message if default_message

      record.errors.add(attribute, MESSAGES[key], errors_options)
    end
  end

end
