class Lalala::Page < ActiveRecord::Base
  include Lalala::Core::ClassInheritableSetting

  self.abstract_class = true
  self.table_name = "pages"

  # Basic properties
  attr_accessible :title, :position

  # Translations
  translates :title, :path_component
  Lalala::Page::Translation.table_name = 'page_translations'

  # Tree
  acts_as_tree dependent: :restrict, order: 'position', name_column: 'path_component'
  include Lalala::Pages::PathHandler

  # Validations
  validates :title,
    presence: true,
    length:   { minimum: 2 }

  validates :position,
    presence:     true,
    numericality: { greater_than_or_equal_to: 0, only_integer: true }

  validates :parent,
    associated: true

  validates_with Lalala::Pages::ChildTypeValidator,
    types:   ->(r){ r.allowed_children }

  validates_with Lalala::Pages::ChildrenLengthValidator,
    attributes: [:children],
    minimum:    ->(r){ r.minimum_children },
    maximum:    ->(r){ r.maximum_children }

  # Before filters
  before_validation :set_default_title,             :on => :create
  before_validation :set_default_position,          :on => :create
  before_validation :build_default_static_children, :on => :create
  before_validation :set_path_component

  # Settings
  define_setting :maximum_children
  define_setting :minimum_children
  define_setting :allowed_children, default: []
  define_setting :allow_destroy,    default: true
  define_setting :allow_create,     default: true
  define_setting :route
  define_setting :form


  def self.default_route
    ->(p){ p.title.to_s.to_url }
  end

  self.route = self.default_route


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

  def self.allowed_child_classes
    self.allowed_children.map do |name|
      if Class === name
        name
      else
        name.to_s.classify.constantize
      end
    end
  end

  def allowed_child_classes
    self.class.allowed_child_classes
  end

private

  def static_children
    []
  end

  def set_default_title
    self.title ||= self.class.to_s.underscore.humanize
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

  def set_path_component
    r = self.route
    case r
    when NilClass
      self.path_component = self.class.default_route.call(self)
    when Proc
      self.path_component = r.call(self)
    when String
      self.path_component = r
    else
      raise "Unexpected path_component value: #{r.inspect}"
    end
  end

end
