class Formtastic::Inputs::ExtendedStringInput < Formtastic::Inputs::StringInput

  def to_html
    Rails.logger.debug("Options: #{options[:prefix]}")
    super
  end

end
