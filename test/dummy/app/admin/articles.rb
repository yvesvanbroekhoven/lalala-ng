ActiveAdmin.register Article do

  index do
    selectable_column
    column :title, :sortable => :title do |m|
      link_to m.title, edit_lalala_post_path(m)
    end
    column :created_at, :sortable => :created_at do |d|
      d.created_at.strftime('%b %d, %Y')
    end
    default_actions
  end


  form do |f|
    f.inputs do
      f.input :title
      f.input :body
      f.input :category, as: :select, collection: %w(A B C)
      f.input :image, as: :single_file
    end
    f.actions
  end

end
