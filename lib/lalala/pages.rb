module Lalala::Pages
  extend ActiveSupport::Autoload

  autoload :PathHandler
  autoload :ChildTypeValidator
  autoload :ChildrenLengthValidator

  autoload :PageLoader
  autoload :PageTypeConstraint
  autoload :RouteMapper

end
