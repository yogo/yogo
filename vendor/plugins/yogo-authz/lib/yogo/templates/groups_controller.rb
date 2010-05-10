module Yogo
  module Templates
    module GroupsController
      
      def self.included(base)
        base.send(:include, ClassMethods)
        
        base.send(:before_filter, "find_#{base.parent_class.name.underscore}")
        base.class_eval <<-FINDING_PARENT
          def find_#{base.parent_class.name.underscore}
            @parent = #{base.parent_class.name}.first(:id => params[:#{base.parent_class.name.underscore}_id]) ||
                                         #{base.parent_class.name.underscore}.first(:name => params[:#{base.parent_class.name.underscore}_id])
          end
        FINDING_PARENT
        
      end
      
      module ClassMethods
        def index
          @groups = @parent.groups

          respond_to do |format|
            format.html { render(:template => 'yogo/template_groups/index') }
          end           
        end

        def show
          @group = @parent.groups.find(params[:id])

          respond_to do |format|
            format.html { render(:template => 'yogo/template_groups/show') }
          end
        end

        def new
          @group = @parent.groups.new

          respond_to do |format|
           format.html { render(:template => 'yogo/template_groups/new') }
          end
        end

        def create
          @group = @parent.groups.create(params["yogo_#{parent_class.name.underscore}_group"])

            respond_to do |format|
            if @group.save
              flash[:notice] = "Group saved successfully."
              format.html { redirect_to(template_groups_url) }
            else
              flash[:warning] = "Unable to create group."
              format.html { render( :action => 'new') }
            end
          end
        end

        private

        def parent_path
 
        end

        def template_groups_path
          eval("#{parent_class.name.underscore}_groups_path(@project)")
        end

        def template_groups_url
          eval("#{parent_class.name.underscore}_groups_url(@project)")
        end

        def template_group_path(group)
          eval("#{parent_class.name.underscore}_group_path(@project,#{group.to_param})")
        end

        def template_group_url(group)
          eval("#{parent_class.name.underscore}_group_url(@project,#{group.to_param})")
        end
        
        def new_template_group_path
          eval("new_#{parent_class.name.underscore}_group_path(@project)")
        end
        
        def new_template_group_url
          eval("new_#{parent_class.name.underscore}_group_url(@project)")
        end
      end # Class Methods
      
    end
  end
end