class Article < ActiveRecord::Base
  attr_accessible :body, :title, :category

  has_one_asset :image

  validates :title,
    presence: true

end
