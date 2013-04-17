require_relative "../../app/uploaders/image"

class CreateImageAssets < ActiveRecord::Migration
  def up
    create_table :image_assets do |t|
      t.string :asset # carrierwave file mount

      t.references :imageable, polymorphic: true
      t.timestamps
    end

    add_index :image_assets, [:imageable_id, :imageable_type]

    ImageAsset.create_translation_table! title: :string, caption: :text
  end

  def down
    drop_table :image_assets

    ImageAsset.drop_translation_table!
  end
end
