class Lalala::FileAsset < Lalala::AbstractAsset
  mount_uploader :asset, ::FileUploader

  def asset=(value)
    if Array === value
      value = value.first
    end

    super(value)
  end
end
