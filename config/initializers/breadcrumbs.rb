Breadcrumb.configure do
  
  # The second parameter here is never evaled, so the string we use must be set.
  crumb :root,                "Projects",         :projects_path
  crumb :project,             '#{@project.name}', :project_path,                 :project
  crumb :project_search,      'Search: #{params[:search_term]}', :search_project_path
  crumb :project_models,      'Models',           :project_yogo_models_path,     :project
  crumb :project_model,       'Model: #{params[:id]}', :project_yogo_model_path, :project
  crumb :project_data_index,  '#{params[:model_id]}',     :project_yogo_data_index_path, '@project.id', '@model.name.demodulize'
  crumb :project_data,        '#{@item.id}',      :project_yogo_data_path,       '@project.id', '@model.name.demodulize', '@item.id'
  crumb :project_data_search, 'Search: #{params[:search_term]}', :search_project_path
  crumb :q,                   '#{query_params unless params[:q].nil?}', :project_yogo_data_path
  
  trail :projects,    :index,         [:root]
  trail :projects,    [:show, :edit], [:root, :project]
  trail :projects,    :search,        [:root, :project_search]
  trail :yogo_models, :index,         [:root, :project, :project_models ]
  trail :yogo_models, [:show, :edit], [:root, :project, :project_model ]
  trail :yogo_data,   :index,         [:root, :project, :project_data_index, :q ]
  trail :yogo_data,   [:show, :edit], [:root, :project, :project_data_index, :project_data ]
  trail :yogo_data,   :search,        [:root, :project, :project_data_index, :project_data_search]

  delimit_with " > "
  dont_link_last_crumb
end