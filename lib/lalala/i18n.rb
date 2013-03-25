module Lalala::I18n

  require 'lalala/i18n/input_helper'
  require 'lalala/i18n/translations_writer'
  require 'lalala/i18n/negotiation'

  Formtastic::FormBuilder.send :include, InputHelper

  ActiveSupport.on_load :active_record do
    ActiveRecord::Base.send :include, TranslationsWriter
  end

end
