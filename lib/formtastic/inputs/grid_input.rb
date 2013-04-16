class Formtastic::Inputs::GridInput
  include Formtastic::Inputs::Base

  def to_html
    object = builder.object
    assets = object.send(method)

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
            template.link_to(thumbnail_html, f.object.asset.url)
          end
        end
      end

      html += template.content_tag :li do
        builder.fields_for(method, assets.build) do |f|
          f.file_field :asset, multiple: true
        end
      end

      html
    end

    input_wrapping { ul }
  end
end
