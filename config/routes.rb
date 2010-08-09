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

    map.connect '/projects/add_site', :controller => 'yogo/projects', :action => 'add_site'  
    map.connect '/projects/add_stream', :controller => 'yogo/projects', :action => 'add_stream'  
    map.connect '/projects/upload_stream', :controller => 'yogo/projects', :action => 'upload_stream'
    map.connect '/projects/create_stream', :controller => 'yogo/projects', :action => 'create_stream'
    # /projects/:project_id/yogo_data/:model_name
    # /projects/:project_id/yogo_data/:model_name/:id
    project.resources :yogo_data, :as => 'yogo_data/:model_id', :controller => 'yogo/data',
                      :collection => { :upload => :post, :search => :get, :upload_stream => :post },
                      :member => { :download_asset => :get, :show_asset => :get }

    # /projects/:project_id/yogo_models/:model_name
    project.resources :yogo_models, :controller => 'yogo/models'

    project.resources :users, :controller => 'yogo/users',
                              :only => [:index, :new, :create],
                              :collection => { :update_user_roles => :post }

  end
  map.page 'pages/:id',
    :controller   => 'pages',
    :action       => 'show',
    :requirements => { :id => /[a-z]+/ }

  map.resources :settings
  map.resource :password, :only => [ :show, :update, :edit ]
  map.resources :users
  map.resources :roles

  # Login & Logout stuff
  map.resource :user_session, :only => [ :show, :new, :create, :destory ]
  map.logout '/logout', :controller => 'user_sessions', :action => 'destroy'
  map.login '/login', :controller => 'user_sessions', :action => 'new'

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "yogo/projects"
end
