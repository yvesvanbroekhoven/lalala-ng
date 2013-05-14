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
        File.join("/storage/assets", super_url)
      else
        super_url
      end
    else
      super_url
    end
  end

end
