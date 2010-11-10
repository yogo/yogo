class SystemRolesController < InheritedResources::Base
  
  respond_to :html, :json
  
  defaults :resource_class => SystemRole,
           :collection_name => 'system_roles',
           :instance_name => 'system_role'
           
   def create
     create! do |format|
       format.html { redirect_to(system_roles_url) }
     end
   end

   def update
     update! do |format|
       format.html { redirect_to(system_roles_url) }
     end
   end

   def delete
     delete! do |format|
       format.html { redirect_to(system_roles_url) }
     end
   end
           
   protected

   def collection
     @system_roles ||= resource_class.paginate(:page => params[:page])
   end

   def resource
     @system_role ||= resource_class.get(params[:id])
   end
   
   def resource_class
     SystemRole.access_as(current_user)
   end
           
end