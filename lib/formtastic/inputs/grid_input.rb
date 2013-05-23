class Formtastic::Inputs::GridInput
  include Formtastic::Inputs::Base

  def to_html
    object = builder.object
    assets = object.send(method)
    asset_model_class = builder.object.class.reflect_on_association(method).class_name.constantize

    # build html
    ul = template.content_tag :ul do
      html = []
      html << Formtastic::Inputs::GridInput.build_assets(assets, asset_model_class, builder, template, method)
      html << Formtastic::Inputs::GridInput.build_errors(assets, asset_model_class, builder, template, method)
      html << Formtastic::Inputs::GridInput.build_actions(assets, asset_model_class, builder, template, method)
      template.raw html.join("")
    end

    input_wrapping { ul }
  end

private

  #
  #  Asset blocks (+ their attributes)
  #
  def self.build_assets(assets, asset_model_class, builder, template, method)
    html = []

    # collect attribute names
    asset_attributes = asset_model_class.accessible_attributes.to_a
    asset_attributes.select! { |x| x.size > 0 and !%w(asset translations_writer).include?(x) }

    # build each
    assets.each_with_index do |asset, idx|
      li = template.content_tag :li, class: "asset", title: asset.asset.file.filename do
        builder.fields_for(method, asset) do |f|
          Formtastic::Inputs::GridInput.build_asset(asset, asset_attributes, f, template)
        end
      end

      html << li
    end

    template.raw(html.join(""))
  end



  def self.build_asset(asset, asset_attributes, f, template)
    html = []

    # html -> link
    html << Formtastic::Inputs::GridInput.build_asset_link(f, template)

    # html -> attributes
    html << template.content_tag(:ol, { class: "attributes" }) do
      inputs = asset_attributes.map do |attribute|
        Formtastic::Inputs::GridInput.build_asset_attribute(attribute, f)
      end

      template.raw <<-EOS
        #{inputs.join}
        <a class="close-button">&#10005;</a>
      EOS
    end

    # return
    template.raw(html.join(""))
  end



  def self.build_asset_link(f, template)
    inner_html = template.raw("")
    filename = f.object.asset.file.filename

    # get thumbnail
    lalala_thumb = if f.object.asset.respond_to?(:lalala_thumb)
      f.object.asset.lalala_thumb
    end

    # thumbnail or file-icon + filename
    inner_html << if url = lalala_thumb.try(:url)
      template.image_tag(url)
    else
      combo = template.raw("")
      combo << template.content_tag(:span, "", class: "file-icon")
      combo << template.content_tag(:span, filename, class: "filename")
      combo
    end

    # return
    template.link_to(inner_html, f.object.asset.url)
  end



  def self.build_asset_attribute(attribute, f)
    args = [attribute.to_sym]
    collection_name = attribute.chomp("_id").pluralize.to_sym

    if attribute.include?("_id") && f.object.respond_to?(collection_name)
      args << {
        as: :select,
        collection: f.object.send(collection_name)
      }
    else
      args << {
        placeholder: attribute
      }
    end

    f.input(*args)
  end



  #
  #  Errors
  #
  def self.build_errors(assets, asset_model_class, builder, template, method)
    html = ""

    asset_errors = assets.map do |asset|
      asset.errors.to_a
    end.flatten

    if asset_errors.present?
      html = <<-EOS
        <li class="errors">
          <ul>%{items}</ul>
        </li>
      EOS

      errors_html = template.raw("")
      asset_errors.each do |error|
        errors_html << template.content_tag(:li, error)
      end

      html.sub("%{items}", errors_html)
    end

    template.raw(html)
  end



  #
  #  Actions
  #
  def self.build_actions(assets, asset_model_class, builder, template, method)
    template.content_tag :li, class: "actions" do
      builder.fields_for(method, assets.build) do |f|
        f.file_field :asset, multiple: true, accept: asset_model_class.extension_white_list
      end
    end
  end

end
