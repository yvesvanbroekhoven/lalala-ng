module Lalala::ActiveRecordMixins::ImageAssets

  # Set accessible attributes and necessary associations
  def self.included(base)
    base.send(:attr_accessible, :images)
    base.send(:has_many, :images, class_name: "ImageAsset", as: :imageable, dependent: :destroy)
  end

  # Images setter which takes care of multiple image upload,
  # extra attributes, destroying images, etc.
  def images=(attrs)
    image_attributes = ImageAsset.accessible_attributes.to_a
    image_attributes.select! { |x| x.size > 0 and x != "asset" }

    attrs.each do |attr|
      if attr.is_a? Hash
        if attr["_destroy"]
          self.images.find(attr["id"]).destroy
        elsif attr.keys.length > 1
          updated_attributes = attr.select { |k, v| image_attributes.include?(k) }
          self.images.find(attr["id"]).assign_attributes(updated_attributes)
        end
      else
        self.images.build(asset: attr)
      end
    end
  end

end
