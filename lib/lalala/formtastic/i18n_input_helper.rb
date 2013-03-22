module Lalala::Formtastic::I18nInputHelper

  def input(method, options = {})
    unless translated?(method)
      return super(method, options)
    end

    begin
      _locale, _object_name = I18n.locale, @object_name

      h = "".html_safe

      locales = I18n.available_locales.dup
      locales.sort!

      if I18n.default_locale
        locales.delete(I18n.default_locale)
        locales.unshift(I18n.default_locale)
      end

      locales.each do |locale|
        I18n.locale  = locale
        @object_name = "#{_object_name}[translations_writer][#{locale}]"

        h << super(method, options)
      end

      h

    ensure
      I18n.locale, @object_name = _locale, _object_name
    end
  end

protected

  def column_for(method) #:nodoc:
    if translated?(method)
      c = @object.class.translation_class.columns_hash[method.to_s]
      return c if c
    end

    super(method)
  end

  def translated?(method)
    @object.respond_to?(:translated?) and @object.translated?(method)
  end

end

Formtastic::FormBuilder.send :include, Lalala::Formtastic::I18nInputHelper
