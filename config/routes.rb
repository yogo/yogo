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
  map.namespace :yogo do |yogo|
    yogo.resources :projects,
                  :member => { :upload => :post }, 
                  :collection => { :loadexample => :post, :search => :get} do |project|
    
      project.resources :collections do |collection|
        collection.resources :items
        collection.resources :properties
      end
      
    end
  end

  map.dashboard "/dashboard", :controller => 'yogo/projects', :action => 'index'
  
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
