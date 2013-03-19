class Lalala::Markdown::MarkdownRenderer < Redcarpet::Render::Base

  NEW_BLOCK = "\n\n"

  def initialize(options)
    super
    @list_counter     = 0
    @table_cells      = []
    @table_rows       = []
    @table_alignments_builder = []
  end

  # ```ruby
  # 1 + 2 # => 3
  # ```
  def block_code(code, language)
    "```#{language}\n#{code.strip}\n```" + NEW_BLOCK
  end

  # > quote
  # > new line
  def block_quote(quote)
    "> " + quote.strip.gsub("\n", "\n> ") + NEW_BLOCK
  end

  def block_html(html)
    html.strip + NEW_BLOCK
  end

  def header(text, level)
    ("#" * level) + " " + text.strip + NEW_BLOCK
  end

  def hrule
    "---" + NEW_BLOCK
  end

  def list(content, type)
    content.strip + NEW_BLOCK
  ensure
    # Reset the list counter
    @list_counter = 0
  end

  def list_item(content, type)
    case type
    when :ordered
      "#{@list_counter}. #{content.strip}\n"
    when :unordered
      "# #{content.strip}\n"
    end
  end

  def paragraph(content)
    content.strip + NEW_BLOCK
  end

  def table(header, body)
    column_count = @table_rows.first.size
    widths       = Array.new(column_count, 0)

    # determine the maximum widths of all the columns
    @table_rows.each do |row|
      row.each_with_index do |cell, idx|
        w = cell.size
        if widths[idx] < w
          widths[idx] = w
        end
      end
    end

    rows       = @table_rows
    alignments = @table_alignments

    delimiter_row = Array.new(column_count, "")
    alignments.each_with_index do |_, idx|
      width = widths[idx]

      case alignments[idx]
      when :left
        cell = ("-" * width)
      when :right
        cell = ("-" * (width - 1)) + ":"
      when :center
        cell = ":" + ("-" * (width - 2)) + ":"
      end

      delimiter_row[idx] = cell
    end

    if header.size > 0
      rows.insert(1, delimiter_row)
    else
      rows.insert(0, delimiter_row)
    end

    rows = rows.map do |row|
      cells = []
      row.each_with_index do |cell, idx|
        width = widths[idx]

        case alignments[idx]
        when :left
          cell = cell + (" " * (width - cell.size))
        when :right
          cell = (" " * (width - cell.size)) + cell
        when :center
          half_width = (width - cell.size) / 2.0
          cell = (" " * half_width.floor) + cell + (" " * half_width.ceil)
        end

        cell = " " + cell + " "

        cells << cell
      end

      "|" + cells.join("|") + "|"
    end

    rows.join("\n") + NEW_BLOCK

  ensure
    @table_rows = []
    @table_alignments = nil
    @table_alignments_builder = []
  end

  def table_row(content)
    if @table_alignments_builder
      @table_alignments = @table_alignments_builder
    end

    @table_rows.push(@table_cells)

    "."
  ensure
    @table_cells = []
    @table_alignments_builder = nil
  end

  def table_cell(content, alignment)
    @table_cells << content

    if @table_alignments_builder
      @table_alignments_builder << alignment
    end

    ""
  end

  def autolink(link, link_type)
    link
  end

  def codespan(code)
    "`" + code + "`"
  end

  def double_emphasis(text)
    "**" + text + "**"
  end

  def emphasis(text)
    "*" + text + "*"
  end

  def image(link, title, alt_text)
    if title.size > 0
      "![#{alt_text}](#{link} #{title})"
    else
      "![#{alt_text}](#{link})"
    end
  end

  def linebreak()
    "  \n"
  end

  def link(link, title, content)
    if title.size > 0
      "[#{content}](#{link} #{title})"
    else
      "[#{content}](#{link})"
    end
  end

  def raw_html(raw_html)
    raw_html
  end

  def triple_emphasis(text)
    "***" + text + "***"
  end

  def strikethrough(text)
    "~~~" + text + "~~~"
  end

  def superscript(text)
    "^" + text
  end

  def entity(text)
    text
  end

  def normal_text(text)
    text
  end

end
