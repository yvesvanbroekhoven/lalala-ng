module Lalala::ActiveRecordMixins::Images

  def self.included(base)
    base.send(:attr_accessible, :images)
    base.send(:has_many, :images, as: :imageable, dependent: :destroy)
  end

  def images=(attrs)
    image_attributes = Image.accessible_attributes.to_a
    image_attributes.select! { |x| x.size > 0 and x != "asset" }

    attrs.each do |attr|
      if attr.is_a? Hash
        if attr["_destroy"]
          self.images.find(attr["id"]).destroy
        elsif attr.keys.length > 1
          updated_attributes = attr.select { |k, v| image_attributes.include?(k) }
          self.images.find(attr["id"]).update_attributes(updated_attributes)
        end
      else
        self.images.build(asset: attr)
      end
    end
  end

end
