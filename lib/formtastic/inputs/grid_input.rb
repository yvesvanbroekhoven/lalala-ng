class Formtastic::Inputs::GridInput
  include Formtastic::Inputs::Base

  def to_html
    object = builder.object
    assets = object.send(method)
    preroll = "#{object.class.table_name.singularize}[#{method}]"

    image_model_class = object.class.reflect_on_association(method).class_name.constantize
    image_attributes = image_model_class.accessible_attributes.to_a
    image_attributes.select! { |x| x.size > 0 and x != "asset" }

    element_attributes = {}
    element_attributes["data-accessible-attributes"] = image_attributes.join(",")

    ul = template.content_tag :ul, element_attributes do
      html = template.raw("")

      assets.each_with_index do |asset, idx|
        html += template.content_tag :li do
          builder.fields_for(method, asset) do |f|
            thumbnail_html = template.image_tag f.object.asset.thumb.url
            h = template.hidden_field_tag "#{preroll}[][id]", f.object.id
            h << template.link_to(thumbnail_html, f.object.asset.url)
            h
          end
        end
      end

      html += template.content_tag :li do
        # name will probably be "#{preroll}[]" in a future rails release
        builder.file_field method, name: "#{preroll}", multiple: true
      end

      html
    end

    input_wrapping { ul }
  end
end
