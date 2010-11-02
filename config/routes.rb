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
                 :member => { :upload => :post, :collect_data => :get },
                 :collection => { :search => :get, :publish_his => :post, :export => :post} do |project|

    project.resources :memberships, :namespace => nil, :controller => "memberships"
    project.resources :sites, :namespace => nil, :controller => 'voeis/sites',
                      :collection => {:save_site => :post}
    project.resources :data_streams, :namespace => nil, :controller => 'voeis/data_streams',
                      :collection => { :pre_upload => :post, :create_stream => :post,
                                       :query => :get, :search => :post, :upload => :post,
                                       :export => :post, :data => :post, :add => :get}
    project.resources :variables, :namespace => nil, :controller => 'voeis/variables'
    project.resources :units, :namespace => nil, :controller => 'voeis/units'
    project.resources :apivs, :namespace => nil, :controller => 'voeis/apivs',
                      :collection => {:create_site => :get, :get_site => :get, :get_all_sites => :get,
                                      :create_variable => :get}
    project.resources :sensor_values, :namespace => nil, :controller => 'voeis/sensor_values'
    project.resources :sensor_types, :namespace => nil, :controller => 'voeis/sensor_types'
    project.resources :data_stream_columns, :namespace => nil, :controller =>'voeis/data_stream_columns'
    project.resources :samples, :namespace => nil, :controller =>'voeis/samples'
    project.resources :sample_materials, :namespace => nil, :controller =>'voeis/sample_materials'
    project.resources :lab_methods, :namespace => nil, :controller =>'voeis/lab_methods'
    project.resources :data_values, :namespace => nil, :controller =>'voeis/data_values',      
                      :collection => { :pre_process=> :get, :pre_upload => :post, :store_sample_data => :post}
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

  map.resources :users, :member => { :api_key_update => :put } do |user|
    user.resources :memberships, :namespace => nil, :controller => "memberships"
  end

  map.resources :roles
  map.resources :system_roles
  map.resources :variables
  map.resources :memberships
  map.resources :settings
  map.resources :search
  map.resources :variable_name_c_vs
  map.resources :sample_medium_c_vs
  map.resources :value_type_c_vs
  map.resources :speciation_c_vs
  map.resources :data_type_c_vs
  map.resources :general_category_c_vs
  map.resources :sample_type_c_vs
  map.resources :lab_methods
  map.resources :sample_materials
  map.resources :field_methods
  map.resource  :password, :only => [ :show, :update, :edit ]
  map.resources :dashboards, :only => [ :show ], :requirements => { :id => /[\w]+/ }
  map.resources :pages, :only => [ :show ], :requirements => { :id => /[\w]+/ }
  map.resources :feedback, :collection => { :email => :post}
  # Login & Logout stuff
  map.resource :user_session, :only => [ :show, :new, :create, :destory ]
  map.logout '/logout', :controller => 'user_sessions', :action => 'destroy'
  map.login '/login', :controller => 'user_sessions', :action => 'new'

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => 'pages', :action => 'show', :id => :home
end
