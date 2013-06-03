class Lalala::Pages::PageTypeConstraint

  def initialize(type)
    type = "#{type}_page"
    type = type.classify

    while type.ends_with?("PagePage")
      type = type[0..-5]
    end

    type = type.constantize
    @type = type
  end

  def matches?(request)
    return false if env["action_dispatch.exception"]
    request.env['lalala.page'] and @type === request.env['lalala.page']
  end

end
