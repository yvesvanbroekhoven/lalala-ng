class Article < ActiveRecord::Base
  attr_accessible :body, :title, :category, :tag_ids

  has_one_asset :image

  # Translations
  translates :title, :body

  # Validations
  validates :title, presence: true

  # Bindings
  has_and_belongs_to_many :tags

end
