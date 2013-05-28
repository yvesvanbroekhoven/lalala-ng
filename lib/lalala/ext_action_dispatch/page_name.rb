module Lalala::ExtActionDispatch::PageName

  def page_name
    @page_name ||= env['PAGE_NAME'].to_s
  end

  def path
    page_name + super
  end

end
