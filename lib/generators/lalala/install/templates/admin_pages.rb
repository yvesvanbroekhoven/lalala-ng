ActiveAdmin.register ApplicationPage, :as => 'Page' do
  # Customize the pages resource

  menu :priority => 2

  # Disable pagination
  config.paginate = false

  # Enable the filter
  # config.filters = false

end
