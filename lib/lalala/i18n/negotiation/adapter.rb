class Lalala::I18n::Negotiation::Adapter

  def default_locale
    I18n.default_locale
  end

  def available_locales
    I18n.available_locales || []
  end

  def locales_for_hostname(hostname)
    available_locales
  end

  def action(env, deterministic)
    return [:call, @env]
  end

end
