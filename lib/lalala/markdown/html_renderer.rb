class Lalala::Markdown::HtmlRenderer < Redcarpet::Render::Base

  URI_PATTERN = %r|^lalala[:][/]{2}.+|

  def initialize(options)
    @inner = Redcarpet::Render::HTML.new(options)
  end

  def autolink(link, link_type)
    if URI_PATTERN === link
      return enhanced_autolink(link, link_type)
    end

    @inner.image(link, title, alt_text)
  end

  def image(link, title, alt_text)
    if URI_PATTERN === link
      return enhanced_image(link, title, alt_text)
    end

    @inner.image(link, title, alt_text)
  end

  def link(link, title, content)
    if URI_PATTERN === link
      return enhanced_link(link, title, content)
    end

    @inner.link(link, title, content)
  end

  %w(
    block_code
    block_quote
    block_html
    header
    hrule
    list
    list_item
    paragraph
    table
    table_row
    table_cell
    autolink
    codespan
    double_emphasis
    emphasis
    linebreak
    raw_html
    triple_emphasis
    strikethrough
    superscript
    entity
    normal_text
    doc_header
    doc_footer
    preprocess
    postprocess
  ).each do |method|
    class_eval <<-RUBY, __FILE__, __LINE__
      def #{method}(*args)
        @inner.#{method}(*args)
      end
    RUBY
  end

end
