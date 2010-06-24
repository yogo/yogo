# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: routes.rb
# 
#
ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  map.resources :projects, :controller => 'yogo/projects',
                :member => { :upload => :post }, 
                :collection => { :loadexample => :post, :search => :get} do |project|
    
    # /projects/:project_id/yogo_data/:model_name
    # /projects/:project_id/yogo_data/:model_name/:id
    project.resources :yogo_data, :as => 'yogo_data/:model_id', :controller => 'yogo/data',
                      :collection => { :upload => :post, :search => :get },
                      :member => { :download_asset => :get, :show_asset => :get }
                          
    # /projects/:project_id/yogo_models/:model_name
    project.resources :yogo_models, :controller => 'yogo/models',
                      :collection => { :refresh_attributes => :post },
                      :member => { :list_attributes => :get }
    
  end
  map.resources :settings
  map.resources :tutorial

  map.dashboard "/dashboard", :controller => 'yogo/projects', :action => 'index'

  # map.connect "/mockup/:action", :controller => 'mockup'
  
  # Wizard stuff
  map.start_wizard  "/project_wizard/name", 
                    :controller => 'project_wizard', :action => 'name'
  map.create_wizard_project "/project_wizard/", 
                            :controller => 'project_wizard', :action => 'create'
  map.csv_question  "/project_wizard/csv_question/:id", 
                    :controller => 'project_wizard', :action => 'csv_question'
  map.import_csv  "/project_wizard/import_csv/:id", 
                  :controller => 'project_wizard', :action => 'import_csv'
  map.upload_csv_wizard "/project_wizard/upload_csv/:id", 
                        :controller => 'project_wizard', :action => 'upload_csv'
  

  map.resource :password, :only => [ :show, :update, :edit ]
  map.resources :users
  # Login & Logout stuff
  map.resource :user_session, :only => [ :show, :new, :create, :destory ]
  map.logout '/logout', :controller => 'user_sessions', :action => 'destroy'
  map.login '/login', :controller => 'user_sessions', :action => 'new'
  
  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "yogo/projects"
end
