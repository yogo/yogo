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
    end
    resources :memberships
    scope :module => "voeis" do
      resources :sites do
        collection do
          post :save_site
        end
      end
      resources :data_streams do
        collection do
          get  :add
          get  :query
          get  :site_sensor_variables
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
          get :create_site
          get :create_variable
          get :get_all_sites
          get :get_site
        end
      end
      resources :sensor_values
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
          post :pre_upload
          post :store_sample_data
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
    member do
      put :api_key_update
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

