if defined?(ActiveAdmin) and defined?(ApplicationPage)
  ActiveAdmin.register ApplicationPage, :as => 'Page' do
    menu priority: 20, html_options: { class: 'icon-page' }

    config.filters  = false
    config.paginate = false

    # Remove action buttons in topbar
    config.clear_action_items!

    # Edit button in topbar only on show
    action_item :only => [:show] do
      if controller.action_methods.include?('edit')
        link_to(I18n.t('active_admin.edit_model', :model => active_admin_config.resource_name), edit_resource_path)
      end
    end


    #
    # Index
    #
    index as: :tree_table, paginator: false, download_links: false do
      selectable_column

      column :position, label: "" do
        %[<i class="drag-handle"></i>].html_safe
      end

      column :title

      actions defaults: false do |page|
        links = ''.html_safe

        if authorized?(ActiveAdmin::Auth::CREATE, page)
          classes = page.allowed_child_classes.select(&:allow_create)
          if classes.size > 0
            dropdown_menu "Add" do
              classes.each do |page_class|
                item page_class.to_s.underscore.humanize, new_resource_path(parent_id: page.to_param, page_type: page_class.to_s)
              end
            end
          end
        end

        if authorized?(ActiveAdmin::Auth::UPDATE, page)
          links << link_to(I18n.t('active_admin.edit'), edit_resource_path(page), :class => "member_link edit_link")
        elsif authorized?(ActiveAdmin::Auth::READ, page)
          links << link_to(I18n.t('active_admin.view'), resource_path(page), :class => "member_link view_link")
        end

        if authorized?(ActiveAdmin::Auth::DESTROY, page) and page.allow_destroy
          links << link_to(I18n.t('active_admin.delete'), resource_path(page), :method => :delete, :data => {:confirm => I18n.t('active_admin.delete_confirmation')}, :class => "member_link delete_link")
        end

        links
      end

    end


    #
    # Form
    #
    form do |f|
      h = "".html_safe
      if f.object.new_record?
        h << f.input(:parent_id, as: :hidden, wrapper_html: { :style => "display:none;" })
        h << f.input(:page_type, as: :hidden, value: f.object.class.to_s, wrapper_html: { :style => "display:none;" })
      end
      h << self.instance_exec(f, &f.object.form)
      h
    end


    #
    # Order action
    #
    collection_action :order, :method => :put do
      unless Array === params[:ordered_ids]
        render status: 422
        return
      end

      # update the pages
      params[:ordered_ids].each_with_index do |id, idx|
        ApplicationPage.update_all({position: idx}, {id: id.to_i})
      end

      render json: { status: "OK" }, status: 200
    end


    #
    # Controller
    #
    controller do

      def new
        parent         = ApplicationPage.find(params[:parent_id])
        page_classname = params[:page_type]

        unless parent.allowed_children.include?(page_classname)
          raise "Invalid page"
        end

        page_class = page_classname.constantize
        @page = page_class.new(params[:page])
        @page.parent_id = parent.id

        new!
      end

      def create
        page_params    = params[:page]
        parent         = ApplicationPage.find(page_params.delete(:parent_id))
        page_classname = page_params.delete(:page_type)

        unless parent.allowed_children.include?(page_classname)
          raise "Invalid page"
        end

        page_class = page_classname.constantize
        @page = page_class.new(params[:page])

        r = create!

        parent.children << @page

        r
      end

    end


    #
    # Sidebar: Related pages
    #
    sidebar "Related pages", :only => [:edit], :if => proc{ page.parent or page.siblings.count > 0 } do
      if page.parent
        div :class => "lalala sidebar message", :id => "lalala_sidebar_message" do
          h4 class: "title" do
            "Parent page"
          end
          div do
            link_to page.parent.title, edit_lalala_page_path(page.parent)
          end
        end
      end

      if page.siblings.count > 0
        div :class => "lalala sidebar message", :id => "lalala_sidebar_message" do
          h4 class: "title" do
            "Siblings"
          end
          ul :class => "lalala sidebar listing ul" do
            page.siblings.each do |sibling|
              li :class => "item" do
                link_to sibling.title, edit_lalala_page_path(sibling)
              end
            end
          end
        end
      end
    end

  end
end
