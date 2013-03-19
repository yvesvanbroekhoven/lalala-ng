class Lalala::Markdown

  require 'lalala/markdown/preview'
  require 'lalala/markdown/active_model'
  require 'lalala/markdown/html_renderer'
  require 'lalala/markdown/markdown_renderer'

  module Handlers
    require 'lalala/markdown/handlers/base'
    require 'lalala/markdown/handlers/youtube'
  end

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
    :link_attributes,
    :link_schemes
  ]

  OPTIONS = PARSER_OPTIONS + RENDERER_OPTIONS

  def initialize(options={})
    options.assert_valid_keys(*OPTIONS)

    @parser_options = options.slice(*PARSER_OPTIONS)
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

    @renderer_options = options.slice(*RENDERER_OPTIONS)
    @renderer_options = {
      filter_html: true,
      no_images: false,
      no_links: false,
      no_styles: true,
      safe_links_only: true,
      with_toc_data: true,
      hard_wrap: false,
      xhtml: false
    }.merge(@renderer_options)
  end

  def options
    {}.merge(@parser_options).merge(@renderer_options)
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
    Redcarpet::Markdown.new(renderer, @parser_options)
  end

  def markdown_renderer
    Lalala::Markdown::MarkdownRenderer.new(@renderer_options)
  end

  def html_renderer
    Lalala::Markdown::HtmlRenderer.new(@renderer_options)
  end

end

ActiveSupport.on_load :active_record do
  ActiveRecord::Base.send :include, Lalala::Markdown::ActiveModel
end
