class Lalala::Pages::PageTypeConstraint

  def initialize(type)
    unless Class === type
      type  = type.to_s.classify
      type += "Page" unless type.ends_with?("Page")
      type  = type.constantize
    end

    @type = type
  end

  def matches?(request)
    request.env['lalala.page'] and @type === request.env['lalala.page']
  end

end
