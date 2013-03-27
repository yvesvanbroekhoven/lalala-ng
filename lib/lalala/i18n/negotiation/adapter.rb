class Lalala::I18n::Negotiation::Adapter

  def default_locale
    I18n.default_locale
  end

  def available_locales
    I18n.available_locales || []
  end

  def default_locale_for_hostname(hostname)
    nil
  end

  def locales_for_hostname(hostname)
    available_locales
  end

  def action(env, deterministic)
    return [:call, env]
  end

  def ignored?(env)
    %r{^/(lalala|assets)(/|$)} === env['PATH_INFO']
  end

end

class Lalala::I18n::Negotiation::TestAdapter < Lalala::I18n::Negotiation::Adapter

  def initialize(default_locale, available_locales)
    @default_locale    = default_locale
    @available_locales = available_locales.values.flatten.compact.uniq
    @domain_locales    = available_locales
  end

  def default_locale
    @default_locale
  end

  def available_locales
    @available_locales
  end

  def locales_for_hostname(hostname)
    @domain_locales[hostname]
  end

end
