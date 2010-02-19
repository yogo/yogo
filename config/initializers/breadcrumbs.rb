Breadcrumb.configure do
  crumb :root, "Projects", :projects_url
  crumb :project, '#{Project.get(params[:id]).name}', :project_url, :id
  crumb :project_embedded, '#{Project.get(params[:project_id]).name}', 'project_url(@project)'
  crumb :project_models, 'Models', :project_yogo_models_url, :project_id
  crumb :project_model, 'Model: #{params[:id]}', :project_yogo_model_url, :params => :id
  #crumb :project_data, "Data", :project_yogo_data_url, :params => :project_id
  
  trail :projects, :index, [:root]
  trail :projects, [:show, :edit], [:root, :project]
  trail :yogo_models, :index, [:root, :project_embedded, :project_models ]
  trail :yogo_models, [:show, :edit], [:root, :project_embedded, :project_model ]
  #trail :yogo_data, [:show, :edit], [:root, :project, :project_data ]

  delimit_with " > "
  dont_link_last_crumb
end