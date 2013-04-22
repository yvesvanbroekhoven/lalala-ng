class Formtastic::Inputs::SingleFileInput
  include Formtastic::Inputs::Base

  def to_html
    object = builder.object
    model_instance = object.send(method)
    model_class = object.class.reflect_on_association(method).class_name.constantize

    html = template.raw("")
    html << template.content_tag(:label, method.to_s.humanize, class: "label")
    html << builder.fields_for(method, model_class.new) do |f|
      f.file_field :asset
    end

    if model_instance
      html << template.content_tag(:div, class: "file-description") do
        f_html = template.raw("")

        if model_class.to_s.underscore.include?("image")
          f_html << template.content_tag(:img, "", src: model_instance.asset.thumb.url)
        end

        if model_instance.asset.file.try(:filename)
          f_html << template.content_tag(:span, model_instance.asset.file.filename)
        end

        f_html
      end
    end

    input_wrapping { html }
  end
end
