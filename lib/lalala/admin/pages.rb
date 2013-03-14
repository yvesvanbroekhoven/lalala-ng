if defined?(ActiveAdmin)
  ActiveAdmin.register ApplicationPage, :as => 'Page' do

    config.filters        = false
    config.paginator      = false
    config.download_links = false

    index as: :tree_table do
      selectable_column
      id_column
      column :title
      default_actions
    end

    form do |f|
      self.instance_exec(f, &f.object.form)
    end
  end
end
