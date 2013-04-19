class Lalala::AbstractAsset < ActiveRecord::Base
  self.abstract_class = true
  self.table_name = "assets"

  attr_accessible :asset, :title, :caption
  translates :title, :caption
  Lalala::AbstractAsset::Translation.table_name = 'asset_translations'

  belongs_to :asset_owner, polymorphic: true
end
