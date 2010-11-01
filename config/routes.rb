# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: routes.rb
#
#
Yogo::Application.routes.draw do
  resources :projects do
    resources :memberships
    resources :sites
    resources :data_streams do
      collection do
        post :pre_upload
        post :create_stream
        get :query
        post :search
        post :upload
        post :export
        post :data
        get :add
      end
    end

    resources :variables
    resources :units
    resources :apiv1
    resources :sensor_values
    resources :sensor_types
    resources :data_stream_columns
    resources :samples
    resources :sample_materials
    resources :lab_methods
    resources :data_values do
      collection do
        get :pre_process
        post :pre_upload
        post :store_sample_data
      end


    end
  end

  namespace :his do
    resources :data_type_c_vs
    resources :censor_code_c_vs
    resources :sources
    resources :methods
    resources :variables
    resources :sites
    resources :data_values
  end

  resources :users do
    resources :memberships
  end

  resources :roles
  resources :system_roles
  resources :variables
  resources :memberships
  resources :settings
  resources :search
  resources :variable_name_c_vs
  resources :sample_medium_c_vs
  resources :value_type_c_vs
  resources :speciation_c_vs
  resources :data_type_c_vs
  resources :general_category_c_vs
  resources :sample_type_c_vs
  resources :lab_methods
  resources :sample_materials
  resources :field_methods
  resource :password
  resources :dashboards
  resources :pages
  resources :feedback do
    collection do
      post :email
    end
  end

  resource :user_session
  match '/logout' => 'user_sessions#destroy', :as => :logout
  match '/login' => 'user_sessions#new', :as => :login
  match '/' => 'pages#show', :id => home
end

