class Lalala::ExtRack::PageLoader

  def initialize(app)
    @app = app
  end

  def call(env)
    if %r{^/(lalala|assets)(/|$)} === env['PATH_INFO']
      return @app.call(env)
    end

    env   = env
    chain = find_chain(env)

    if chain.present?
      update_env(env, chain)
    end

    @app.call(env)
  end

protected

  def find_chain(env)
    path_info       = env['PATH_INFO']
    path_components = path_info.split('/')

    path_components.unshift('') unless path_components.first == ''
    return ApplicationPage.find_chain_for_path(path_components)
  end

  def update_env(env, chain)
    pages     = []
    page_name = "/"
    path_info = env['PATH_INFO'].to_s

    chain.each do |(page, path_component)|
      page_name = File.join(page_name, path_component)
      path_info = path_info[(1 + path_component.size)..-1]

      pages.push page
    end

    unless path_info.starts_with?('/')
      path_info = "/" + path_info
    end

    if page_name == "/"
      page_name = ""
    end

    if path_info.blank?
      path_info = "/"
    end

    env['lalala.page_chain'] = pages
    env['lalala.page']       = pages.last
    env['PATH_INFO']         = path_info

    unless page_name.blank?
      env['PAGE_NAME'] = page_name
    end
  end

end
