class Lalala::I18n::Negotiation::DecisionMaker

  def initialize(adapter, env=nil)
    @adapter = adapter
    @env     = env
  end

  # @returns [action, arg]
  def determine_routing_path(env)
    new(@adapter, env.dup)._determine_routing_path
  end

protected

  def _determine_routing_path
    if m = one_available_locale?
      @env['rack.locale'] = m[0]
      return action(@env, true)
    end

    if m = hostname_with_one_available_locale?
      @env['rack.locale'] = m[0]
      return action(@env, true)
    end

    if m = first_path_component_is_locale?
      @env['rack.locale'] = m[0]
      @env['PATH_INFO']   = m[1]
      return action(@env, true)
    end

    if m = accept_language_is_available?
      @env['rack.locale'] = m[0]
      return action(@env, false)
    end

    @env['rack.locale'] = default_locale.to_sym
    return action(@env, true)
  end

private

  def default_locale
    @adapter.default_locale.to_sym
  end

  def one_available_locale?
    if available_locales.size == 1
      return [available_locales.first.to_sym]
    end

    if default_locale
      return [default_locale.to_sym]
    end

    return nil
  end

  def hostname_with_one_available_locale?
    if locales_for_hostname.size == 1
      return [locales_for_hostname.first.to_sym]
    end

    return nil
  end

  def first_path_component_is_locale?
    if locale_regex === path_info
      locale = $1
      path   = $2

      path = "/" if path == ""

      return [locale.to_sym, path]
    end

    return nil
  end

  def accept_language_is_available?
    header = @env['HTTP_ACCEPT_LANGUAGE'] || ""

    accepted_locales = header.split(",")
    accepted_locales = accepted_locales.map do |l|
      l = l.strip
      l = l.split(";q=")
      l.push "1.0" if l.size < 2
      l
    end

    accepted_locales = accepted_locales.sort_by do |(_, qval)|
      qval.to_f * -1.0
    end

    accepted_locales = accepted_locales.map do |(locale, _)|
      locale
    end

    accepted_locale = accepted_locales.detect do |locale|
      (locale == "*") or locales_for_hostname_set.include?(locale)
    end

    if accepted_locale == "*"
      accepted_locale = nil
    end

    if accepted_locale
      return [accepted_locale.to_sym]
    end

    return nil
  end

  def default_locale
    @_default_locale ||= @adapter.default_locale
  end

  def available_locales
    @_available_locales ||= @adapter.available_locales
  end

  def locales_for_hostname
    @_locales_for_hostname ||= @adapter.locales_for_hostname(hostname)
  end

  def locales_for_hostname_set
    @_locales_for_hostname_set ||= locales_for_hostname.map(&:to_s)
  end

  def hostname
    @_hostname ||= @env['HTTP_HOST'].split(':').first
  end

  def path_info
    @_path_info ||= @env['PATH_INFO']
  end

  def locale_regex
    @_locale_regex ||= begin
      locales = locales_for_hostname
      locales = locales.map do |locale|
        Regexp.escape(locale.to_s)
      end
      locales = locales.join("|")

      %r{^[/]?(#{locales})([/].*)$}
    end
  end

end
