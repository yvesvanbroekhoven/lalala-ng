module Lalala::Markdown::InputHelper
  extend ActiveSupport::Concern

  def input(method, options = {})

    if ( @object.respond_to?("#{method}_html") )
      input_html = options[:input_html] || {}
      input_html[:class] = [input_html[:class], 'markdown'].flatten.compact.join(" ")
      options[:input_html] = input_html
    end

    super(method, options)
  end
end
