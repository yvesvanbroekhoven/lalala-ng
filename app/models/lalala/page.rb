class Lalala::Page < ActiveRecord::Base
  include Lalala::Core::ClassInheritableSetting

  # table name
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


  # Settings
  define_setting :allow_children, default: true
  define_setting :maximum_children
  define_setting :minimum_children
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

end
