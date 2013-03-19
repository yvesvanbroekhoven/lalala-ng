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

        resource[key] = val

        @content = resource.send("#{key}_html")

        render layout: 'lalala/markdown', template: 'lalala/markdown/preview'

      end
    end
  end

end
