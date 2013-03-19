class Lalala::Markdown::HtmlRenderer < Redcarpet::Render::HTML


  def initialize(options)
    super(options)

    # extend InstanceMethods
  end

  module InstanceMethods

    URI_PATTERN = %r|^lalala[:][/]{2}.+|


    def autolink(link, link_type)
      if URI_PATTERN === link
        return enhanced_autolink(link, link_type)
      end

      "<a href="
    end

    def image(link, title, alt_text)
      if URI_PATTERN === link
        return enhanced_image(link, title, alt_text)
      end

      o_image(link, title, alt_text)
    end

    def link(link, title, content)
      if URI_PATTERN === link
        return enhanced_link(link, title, content)
      end

      o_link(link, title, content)
    end

  end

end
