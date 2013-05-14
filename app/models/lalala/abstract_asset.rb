class Lalala::AbstractAsset < ActiveRecord::Base
  include Lalala::ExtActiveRecord::I18nTranslationsWriter::Writer

  self.abstract_class = true
  self.table_name = "assets"

  attr_accessible :asset, :title, :caption, :translations_writer

  translates :title, :caption
  Lalala::AbstractAsset::Translation.table_name = 'asset_translations'

  belongs_to :asset_owner, polymorphic: true

  def self.extension_white_list
    list = if self.uploaders and self.uploaders[:asset]
      self.uploaders[:asset].new.try(:extension_white_list)
    end

    list = list || []
    list.map { |e| ".#{e}" }.join(",")
  end

end
