class Formtastic::Inputs::GridInput
  include Formtastic::Inputs::Base

  def to_html
    object = builder.object
    assets = object.send(method)

    asset_model_class = object.class.reflect_on_association(method).class_name.constantize
    asset_attributes = asset_model_class.accessible_attributes.to_a
    asset_attributes.select! { |x| x.size > 0 and !%w(asset translations_writer).include?(x) }

    ul = template.content_tag :ul do
      html = template.raw("")

      assets.each_with_index do |asset, idx|
        html += template.content_tag :li, class: "asset" do
          builder.fields_for(method, asset) do |f|
            lalala_thumb = f.object.asset.lalala_thumb

            if lalala_thumb
              link_inner_html = template.image_tag(lalala_thumb.url)
            else
              link_inner_html = ""
            end

            asset_html = template.raw("")
            asset_html << template.link_to(link_inner_html, f.object.asset.url)
            asset_html << template.content_tag(:ol, { class: "attributes" }) do
              inputs = asset_attributes.map do |ia|
                f.input ia.to_sym, placeholder: ia
              end

              template.raw(inputs.join) + template.content_tag(
                :a, template.raw("&#10005;"), class: "close-button"
              )
            end
            asset_html
          end
        end
      end

      html += template.content_tag :li do
        builder.fields_for(method, assets.build) do |f|
          f.file_field :asset, multiple: true, accept: asset_model_class.extension_white_list
        end
      end

      html
    end

    input_wrapping { ul }
  end
end
