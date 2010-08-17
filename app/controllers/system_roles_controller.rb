class UsersController < InheritedResources::Base
  
  respond_to :html, :json
  
  defaults :resource_class => SystemRole,
           :collection_name => 'system_roles',
           :instance_name => 'system_role'
           
   protected

   def collection
     @roles ||= resource_class.all
   end

   def resource
     @role ||= resource_class.get(params[:id])
   end
           
end