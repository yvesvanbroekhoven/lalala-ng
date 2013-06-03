module Lalala::Pages::Helpers
  extend ActiveSupport::Concern

  included do
    helper_method :current_page_chain, :current_page
  end

protected

  def current_page_chain
    request.env["lalala.page_chain"] or []
  end

  def current_page
    request.env["lalala.page"]
  end

end
