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
    member do
      post :upload
      get  :collect_data
    end
    collection do
      get  :search
      post :export
      post :publish_his
      get  :get_user_projects
    end
    resources :memberships
    scope :module => "voeis" do
      resources :sites do
        collection do
          post :save_site
          get :site_samples
        end
      end
      resources :data_streams do
        collection do
          get  :add
          get  :query
          get  :data_stream_sensor_variables
          get  :site_data_streams
          post :pre_upload
          post :create_stream
          post :search
          post :upload
          post :export
          post :data
        end
      end

      resources :variables 
      resources :units
      resources :apivs do
        collection do
          get :dojo_variables_for_tree
          get :create_project_site
          get :create_project_variable
          get :update_project_site
          get :update_project_variable
          get :update_voeis_variable
          get :get_project_sites
          get :get_voeis_sites
          get :get_voeis_sites
          get :get_project_site
          get :get_project_data_templates
          get :get_project_variables
          get :get_project_variable
          get :get_voeis_variables
          get :get_dojo_voeis_variables
          get :get_project_sample
          get :get_project_samples
          get :get_project_sample_measurements
          get :get_data_stream_data
          get :get_project_site_data
          get :get_project_site_sensor_data_last_update    
          get :get_project_variable_data   
          post :upload_logger_data
          post :create_project_sample
          post :create_project_sample_measurement
          post :import_voeis_variable_to_project 
          post :create_project_sensor_value
          post :create_project_sensor_type
          post :create_project_data_stream
          post :create_project_data_stream_column
        end
      end
      resources :sensor_values do
        collection do
          get   :new_field_measurement
          post   :create_field_measurement
        end
      end
      resources :sensor_types
      resources :data_stream_columns
      resources :samples do
        collection do
          get   :query
          get   :site_sample_variables
          post  :export
          post  :search
        end
      end
      resources :sample_materials
      resources :lab_methods
      resources :data_values do
        collection do
          get  :pre_process
          post  :pre_process_samples_file
          get  :pre_process_samples_file_upload
          post :store_samples_and_data_from_file
          get  :pre_process_samples
          get  :pre_process_sample_file_upload
          post :pre_process_sample_file
          get  :pre_process_samples_and_data
          get  :pre_process_varying_samples_with_data
          post :pre_upload
          post :pre_upload_samples_and_data
          post :pre_upload_varying_samples_with_data
          post :store_sample_data
          post :store_samples_and_data
          post :store_varying_samples_with_data
        end
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
    collection do
      post :api_key_update
      post :change_password
      get :reset_password
      post :email_reset_password
    end
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
  resource  :password,                :only => [:show, :update, :edit]
  resources :dashboards,              :only => [:show], :requirements => {:id => /[\w]+/}
  resources :pages,                   :only => [:show], :requirements => {:id => /[\w]+/}
  resources :feedback do
    collection do
      post :email
    end
  end
  resources :voeis_mailer
  resource :user_session,             :only => [ :show, :new, :create, :destroy ]
  match '/logout' => 'user_sessions#destroy', :as => :logout
  match '/login' => 'user_sessions#new', :as => :login
  match '/' => 'pages#show', :id => :home, :as => :root
end

