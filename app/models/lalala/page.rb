class Lalala::Page < ActiveRecord::Base
  include Lalala::Core::ClassInheritableSetting

  self.abstract_class = true
  self.table_name = "pages"

  # Basic properties
  attr_accessible :title, :body, :position

  # Translations
  translates :title, :body, :path_component
  Lalala::Page::Translation.table_name = 'page_translations'

  # Tree
  acts_as_tree dependent: :restrict, order: 'position', name_column: 'path_component'
  include Lalala::Pages::PathHandler

  # Validations
  validates :static_uuid,
    uniqueness: { allow_blank: true, scope: [:parent_id] }

  validates :title,
    presence: true,
    length:   { minimum: 2 }

  validates :position,
    presence:     true,
    numericality: { greater_than_or_equal_to: 0, only_integer: true }

  # validates :parent,
  #   associated: true

  validates_with Lalala::Pages::ChildTypeValidator,
    types:   ->(r){ r.allowed_children }

  validates_with Lalala::Pages::ChildrenLengthValidator,
    attributes: [:children],
    minimum:    ->(r){ r.minimum_children },
    maximum:    ->(r){ r.maximum_children }

  # Before filters
  before_validation :set_default_title,             :on => :create
  before_validation :set_default_position,          :on => :create
  before_validation :build_default_static_children
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

  def static?
    self.static_uuid.present?
  end

  def destroy_recursively
    self.children.each(&:destroy_recursively)
    self.destroy
  end

private

  def static_children
    {}
  end

  def set_default_title
    self.title ||= self.class.to_s.underscore.humanize
  end

  def set_default_position
    # set to the curent UNIX timestamp
    self.position ||= Time.now.utc.to_i
  end

  def build_default_static_children
    next_children = static_children
    return if next_children.blank?

    unless Hash === next_children
      raise "Expected a Hash"
    end

    next_children = next_children.stringify_keys

    prev_children = self.children
    prev_children = prev_children.all.select(&:static_page?)
    prev_children = prev_children.index_by(&:static_uuid)

    created_uuids   = next_children.keys - prev_children.keys
    destroyed_uuids = prev_children.keys - next_children.keys
    updated_uuids   = next_children.keys - created_uuids

    children = []

    created_uuids.each do |uuid|
      next_page = next_children[uuid]
      next_page.static_uuid = uuid
      children.push next_page
    end

    updated_uuids.each do |uuid|
      prev_page = prev_children[uuid]
      next_page = next_children[uuid]

      if next_page.class != prev_page.class
        new_page = prev_page.becomes(next_page.class)
      else
        new_page = prev_page
      end

      non_translated_attrs = new_page.class.attribute_names
      translated_attrs     = new_page.class.translated_attribute_names.map(&:to_s)

      non_translated_attrs -= ['id', 'parent_id', 'static_uuid', 'type']
      translated_attrs     -= ['path_component']

      # update normal attributes
      non_translated_attrs.each do |attr|
        next if prev_page.send(attr).present?
        next if next_page.send(attr).blank?

        new_page.send("#{attr}=", next_page.send(attr))
      end

      # update translated attributes
      begin
        _locale = I18n.locale
        I18n.available_locales.each do |locale|
          I18n.locale = locale

          translated_attrs.each do |attr|
            next if prev_page.send(attr).present?
            next if next_page.send(attr).blank?

            new_page.send("#{attr}=", next_page.send(attr))
          end

          new_page.path_component = nil
        end

      ensure
        I18n.locale = _locale
      end

      children.push new_page
    end

    destroyed_uuids.each do |uuid|
      prev_children[uuid].destroy_recursively
    end

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
