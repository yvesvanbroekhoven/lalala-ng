class Lalala::Page < ActiveRecord::Base
  include Lalala::Core::ClassInheritableSetting

  self.abstract_class = true
  self.table_name = "pages"

  # Basic properties
  attr_accessible :title, :position

  # Tree
  acts_as_tree dependent: :restrict, order: 'position'

  # Validations
  validates :title,
    presence: true,
    length:   { minimum: 2 }

  validates :position,
    presence:     true,
    numericality: { greater_than_or_equal_to: 0, only_integer: true }

  validates :parent,
    associated: true

  validates_with Lalala::Pages::ChildTypeValidator, types: ->(r){ r.allowed_children }

  # Before filters
  before_validation :set_default_title,             :on => :create
  before_validation :set_default_position,          :on => :create
  before_validation :build_default_static_children, :on => :create

  # Settings
  define_setting :maximum_children
  define_setting :minimum_children
  define_setting :allowed_children, default: []
  define_setting :allow_destroy,    default: true
  define_setting :form


  # The form
  def self.form(&block)
    if block
      @form = block
    elsif defined?(@form)
      @form ||= default_form
    else
      superclass.form
    end
  end

  def self.default_form
    proc do |f|
      f.inputs "Details" do
        f.input :title
      end
      f.buttons
    end
  end

  self.form = self.default_form

private

  def static_children
    []
  end

  def set_default_title
    self.title ||= self.class.to_s.humanize
  end

  def set_default_position
    # set to the curent UNIX timestamp
    self.position ||= Time.now.utc.to_i
  end

  def build_default_static_children
    children = static_children
    return if children.blank?

    self.children = children
  end

end
