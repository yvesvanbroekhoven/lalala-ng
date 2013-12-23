class Formtastic::Inputs::PrefixInput
  include Formtastic::Inputs::Base

  def to_html
    object = builder.object
    model_instance = object.send(method)
    model_class = object.class.reflect_on_association(method).klass

    html = template.raw("")
    html << label_html
    html << builder.fields_for(method, model_class.new) do |f|
      f.file_field :asset, accept: model_class.extension_white_list, id: input_html_options[:id]
    end

    if model_instance
      html << template.content_tag(:div, class: "file-description") do
        filename = model_instance.asset.file.try(:filename)
        f_html = template.raw("")

        if model_class.to_s.include?("Image")
          f_html << template.content_tag(:img, "", src: model_instance.asset.lalala_thumb.url)
        end

        if filename
          f_html << template.content_tag(:span, filename)
        end

        f_html
      end
    end

    input_wrapping { html }
  end
end
