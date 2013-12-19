class Article < ActiveRecord::Base
  attr_accessible :body, :title, :category, :tag_ids

  has_one_asset :image

  # Translations
  translates :title, :body

  # Validations
  validates :title, presence: true

  # Scopes
  scope :catA, where(:category => "A")
  scope :catB, where(:category => "B")
  scope :catC, where(:category => "C")

  # Bindings
  has_and_belongs_to_many :tags

  def get_tags
    self.tags
  end

end
