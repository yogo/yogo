# This is really an example class for someone to template off of
# 
# To use
#   Delayed::Job.enqueue(ProcessAFile.new(a_user,a_project,path_to_csv,template_id,site_id))
class ProcessAFile
  attr_accessor :project_id
  attr_accessor :user_id
  attr_accessor :file_path
  attr_accessor :data_stream_template_id
  attr_accessor :site_id
  
  def initialize(project, user, path, template_id, site_id)
    self.project_id = project.id
    self.user_id = user.id
    self.file_path = path
    self.data_stream_template_id = template_id
    self.site_id
  end
  
  def perform
    # Get the user and the project associated with this action
    user = User.get(self.user_id)
    project = Project.get(self.project_id)
    
    # Perform the action
    project.managed_repository {
      Voeis::SensorVariable.parse_logger_csv(self.file_path, self.data_stream_template_id, self.site_id)
    }
    
    # Message the user when action is complete.
    VoeisMailer.email(user.login, "Job complete", "Your job completed successfully.")
  end
end