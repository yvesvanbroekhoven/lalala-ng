class Lalala::Pages::PageTypeConstraint

  def initialize(type)
    @type = type.constantize
  end

  def matches?(request)
    return false if request.env["action_dispatch.exception"]
    request.env['lalala.page'] and @type === request.env['lalala.page']
  end

end
