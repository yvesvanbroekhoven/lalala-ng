class ImageAsset < ActiveRecord::Base
  attr_accessible :asset, :title, :caption
  translates :title, :caption

  belongs_to :imageable, polymorphic: true
  mount_uploader :asset, ImageUploader
end
