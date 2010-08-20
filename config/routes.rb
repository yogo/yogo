# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: routes.rb
#
#
ActionController::Routing::Routes.draw do |map|
  map.resources :projects,
                 :member => { :upload => :post },
                 :collection => { :search => :get} do |project|

    project.resources :memberships, :namespace => nil, :controller => "memberships"
    project.resources :users, :namespace => nil, :controller => "users"

    project.resources :sites, :namespace => nil, :controller => 'voeis/sites',
                      :collection => {:add_site => :get, :save_site => :post}

    project.resources :data_streams, :namespace => nil, :controller => 'voeis/data_streams',
                      :collection => { :pre_upload => :post, :create_stream => :post}
    project.resources :variables, :namespace => nil, :controller => 'voeis/variables'
    project.resources :units, :namespace => nil, :controller => 'voeis/units'
    project.resources :sensor_values, :namespace => nil, :controller => 'voeis/sensor_values'
    project.resources :sensor_types, :namespace => nil, :controller => 'voeis/sensor_types'
    project.resources :data_stream_columns, :namespace => nil, :controller =>'voeis/data_stream_columns'

  end

  map.namespace :his do |his|
    his.resources :data_type_c_vs #, :requirements => { :id => /[a-zA-Z]+/ }
    his.resources :censor_code_c_vs #, :requirements => { :id => /[a-zA-Z]+/ }
    his.resources :sources #, :requirements => { :id => /[a-zA-Z]+/ }
    his.resources :methods #, :requirements => { :id => /[a-zA-Z]+/ }
    his.resources :variables #, :requirements => { :id => /[a-zA-Z]+/ }
    his.resources :sites #, :requirements => { :id => /[a-zA-Z]+/ }
    his.resources :data_values#, :requirements => { :id => /[a-zA-Z]+/ }
  end

  map.resources :users do |user|
    user.resources :memberships, :namespace => nil, :controller => "memberships"
  end

  map.resources :roles
  map.resources :memberships
  map.resources :settings
  map.resources :search
  map.resource  :password, :only => [ :show, :update, :edit ]
  map.resources :dashboards, :only => [ :show ], :requirements => { :id => /[\w]+/ }
  map.resources :pages, :only => [ :show ], :requirements => { :id => /[\w]+/ }

  # Login & Logout stuff
  map.resource :user_session, :only => [ :show, :new, :create, :destory ]
  map.logout '/logout', :controller => 'user_sessions', :action => 'destroy'
  map.login '/login', :controller => 'user_sessions', :action => 'new'

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "projects"
end
