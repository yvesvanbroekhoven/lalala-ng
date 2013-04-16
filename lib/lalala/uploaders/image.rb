class Lalala::Uploaders::Image < Lalala::Uploaders::File

  include CarrierWave::MiniMagick
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper

  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
