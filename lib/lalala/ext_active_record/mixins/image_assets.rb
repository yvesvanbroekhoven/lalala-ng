module Lalala::ExtActiveRecord::Mixins::ImageAssets

  # Set accessible attributes and necessary associations
  def self.included(base)
    base.send(:attr_accessible, :images_attributes)
    base.send(:has_many, :images, class_name: "ImageAsset", as: :imageable, dependent: :destroy)
    base.send(:accepts_nested_attributes_for, :images, allow_destroy: true)
  end

end
