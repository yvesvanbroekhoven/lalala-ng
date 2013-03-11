ActiveAdmin.setup do |config|

  # Set a default site title
  config.site_title = [
    "Lalala",
    Rails.application.class.name.sub(/^Client/, '').split("::").first.titlecase,
  ].join(' - ')

  if !Rails.env.production?
    config.site_title += " (#{Rails.env.to_s.titlecase})"
  end

  # Set the root namespace to /lalala
  config.default_namespace = :lalala

  # Disable the comments
  config.allow_comments = false

end
