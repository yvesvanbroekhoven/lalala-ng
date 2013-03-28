class Lalala::Public::PagesController < ::ApplicationController

  before_filter :load_page

  def show
    Rails.logger.debug "SCRIPT_NAME: #{request.env['SCRIPT_NAME'].inspect}"
    Rails.logger.debug "PATH_INFO:   #{request.env['PATH_INFO'].inspect}"
    Rails.logger.debug "page path:   #{@page.ancestry_path.inspect}"
  end

private

  def load_page
    @page = env['lalala.page']

    unless @page
      raise ActionController::RoutingError.new("No page for path: "+request.path)
    end
  end

end
