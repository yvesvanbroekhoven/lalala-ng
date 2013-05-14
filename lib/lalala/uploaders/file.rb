class Lalala::Uploaders::File < CarrierWave::Uploader::Base

  def store_dir
    if Rails.env.production? or Rails.env.staging?
      "#{model.class.to_s.underscore}/#{model.id}"
    else
      "uploads/#{model.class.to_s.underscore}/#{model.id}"
    end
  end

  def url(*)
    super_url = super
    if Rails.env.production? or Rails.env.staging?
      if super_url
        AssetURL.new(File.join("/storage/assets", super_url))
      else
        super_url
      end
    else
      super_url
    end
  end

  # This class circumvents the Sprockets asset path rewriting
  # by pretending that it is a full URL.
  #
  # @see
  #   https://mrhenry.basecamphq.com/projects/10235776-hetpaleis/todo_items/164031435/comments (internal)
  #   http://apidock.com/rails/ActionView/Helpers/AssetTagHelper/image_tag
  #   http://apidock.com/rails/v3.2.13/ActionView/Helpers/AssetTagHelper/path_to_image
  #   http://apidock.com/rails/ActionView/Helpers/AssetTagHelper/image_path
  #   http://apidock.com/rails/ActionView/AssetPaths/compute_public_path
  #   http://apidock.com/rails/v3.2.13/ActionView/AssetPaths/is_uri%3F
  class AssetURL < String

    def to_s
      self
    end

    def =~(pattern)
      return true
    end

  end

end
