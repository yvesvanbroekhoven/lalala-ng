class Lalala::ImageAsset < Lalala::AbstractAsset
  mount_uploader :asset, ::ImageUploader

  def asset=(value)
    if Array === value
      value = value.first
    end

    super(value)
  end
end
