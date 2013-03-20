class Lalala::Public::PagesController < ::ApplicationController

  before_filter :load_page

  def show
  end

private

  def load_page
    path  = (params[:path] || "").split('/')
    path.unshift("") unless path.first == ""

    @page = ApplicationPage.find_by_path(path)

    unless @page
      raise ActionController::RoutingError.new("No page for path: "+path.join('/'))
    end
  end

end
