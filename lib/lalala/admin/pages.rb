if defined?(ActiveAdmin)
  ActiveAdmin.register ApplicationPage, :as => 'Page' do

    config.filters = false

    index as: :tree_table, paginator: false, download_links: false do
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
