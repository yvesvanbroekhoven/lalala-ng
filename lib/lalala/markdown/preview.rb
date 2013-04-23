module Lalala::Markdown::Preview

  def self.hookup
    d = ActiveAdmin::Event
    e = ActiveAdmin::Resource::RegisterEvent

    d.subscribe e do |resource|
      Lalala::Markdown::Preview.add_preview_action(resource)
    end
  end

  def self.add_preview_action(resource_spec)
    resource_spec.dsl.run_registration_block do
      member_action :preview, :method => :post do

        if resource_params.size > 1
          raise "Expects exactly 1 param"
        end

        instance_params = resource_params.first

        if instance_params.size > 1
          raise "Expects exactly 1 param"
        end

        key = instance_params.keys.first
        val = instance_params[key]

        if key.to_s == 'translations_writer'
          instance_params = val

          if instance_params.size > 1
            raise "Expects exactly 1 param"
          end

          key = instance_params.keys.first
          val = instance_params[key]

          instance_params = val

          if instance_params.size > 1
            raise "Expects exactly 1 param"
          end

          key = instance_params.keys.first
          val = instance_params[key]
        end

        resource[key] = val

        unless resource.respond_to?("#{key}_html")
          raise "Column (#{key}) is not a markdown column"
        end

        @content = resource.send("#{key}_html")

        render layout: 'lalala/markdown', template: 'lalala/markdown/preview'

      end
    end
  end

end
