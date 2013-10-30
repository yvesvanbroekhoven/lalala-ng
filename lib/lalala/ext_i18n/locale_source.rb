module Lalala::ExtI18n::LocaleSource

  def locale_source
    Thread.current['i18n.local_source']
  end

  def locale_source=(val)
    Thread.current['i18n.local_source'] = val
  end

end
