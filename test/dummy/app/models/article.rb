class Article < ActiveRecord::Base
  attr_accessible :body, :title, :category

  has_one_asset :image

  # Translations
  translates :title, :body

  # Validations
  validates :title, presence: true

  scope :catA, where(:category => "A")
  scope :catB, where(:category => "B")
  scope :catC, where(:category => "C")

end
