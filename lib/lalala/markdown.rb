class Lalala::Markdown

  require 'redcarpet'
  require 'lalala/markdown/html_renderer'
  require 'lalala/markdown/markdown_renderer'

  PARSER_OPTIONS = [
    :no_intra_emphasis,
    :tables,
    :fenced_code_blocks,
    :autolink,
    :strikethrough,
    :lax_spacing,
    :space_after_headers,
    :superscript
  ]

  RENDERER_OPTIONS = [
    :filter_html,
    :no_images,
    :no_links,
    :no_styles,
    :safe_links_only,
    :with_toc_data,
    :hard_wrap,
    :xhtml,
    :link_attributes
  ]

  def initialize(options={})
    @parser_options = options.slice(PARSER_OPTIONS)
    @parser_options = {
      no_intra_emphasis: true,
      tables: false,
      fenced_code_blocks: false,
      autolink: true,
      strikethrough: false,
      lax_spacing: false,
      space_after_headers: false,
      superscript: false
    }.merge(@parser_options)

    @rendered_options = options.slice(RENDERER_OPTIONS)
    @rendered_options = {
      filter_html: true,
      no_images: false,
      no_links: false,
      no_styles: true,
      safe_links_only: true,
      with_toc_data: true,
      hard_wrap: false,
      xhtml: false
    }.merge(@rendered_options)
  end

  def render(text)
    md = parser(html_renderer)
    md.render(text)
  end

  def format(text)
    md = parser(markdown_renderer)
    md.render(text)
  end

private

  def parser(renderer)
    Redcarpet::Markdown.new(rendered, @parser_options)
  end

  def markdown_renderer
    Lalala::Markdown::MarkdownRenderer.new(@rendered_options)
  end

  def html_renderer
    Lalala::Markdown::HtmlRenderer.new(@rendered_options)
  end

end
