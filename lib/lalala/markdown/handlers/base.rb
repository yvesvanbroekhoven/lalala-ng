class Lalala::Markdown::Handlers::Base

  def image(url, alt=nil, title=nil)
    ""
  end

  def link(url, content=url, title=nil)
    ""
  end

private

  def helpers
    ApplicationController.helpers
  end

end
