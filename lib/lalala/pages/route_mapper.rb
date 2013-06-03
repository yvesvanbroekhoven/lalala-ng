module Lalala::Pages::RouteMapper

  # pages(:about, to: 'about#show')
  # pages(:about, to: 'about#show') do
  #   get '/team/:member', to: 'about#team_member'
  # end
  # pages(:about) do
  #   get '/team/:member', to: 'about#team_member'
  # end
  def pages(*args)
    options = args.extract_options!
    options = options.dup

    unless args.size == 1 and Symbol === args[0]
      raise ArgumentError, "expected a page type"
    end

    type    = Lalala::Pages::RouteMapper.page_class_name(args[0])
    options = { as: type.underscore }.merge(options)
    options[:constraints] = Lalala::Pages::PageTypeConstraint.new(type)

    match '/', options

    if block_given?
      scope(options.except(:to,:action,:controller)) { yield }
    end

    self
  end

  def self.page_class_name(type)
    type = "#{type}_page"
    type = type.classify

    while type.ends_with?("PagePage")
      type = type[0..-5]
    end

    type
  end

end
