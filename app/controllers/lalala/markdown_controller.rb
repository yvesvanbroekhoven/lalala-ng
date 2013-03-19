class Lalala::MarkdownController < ActionController::Base

  def cheatsheet
    render layout: false
  end

  def preview
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, tables: true)
    @content = markdown.render(params[:data]).html_safe
    render layout: 'lalala/markdown'
  end

end
