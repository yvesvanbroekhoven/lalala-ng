ActiveAdmin.register Article do

  form do |f|
    f.inputs do
      f.input :title
      f.input :body
      f.input :image, as: :single_file
    end
    f.actions
  end

end
