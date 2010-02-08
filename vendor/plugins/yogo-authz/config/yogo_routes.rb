ActionController::Routing::Routes.draw do |map|
  map.resource :account, :controller => "yogo/account"
  map.resources :users, :controller => "yogo/users" do |user|
    user.resource :membership, :controller => "yogo/memberships", :except => [:update, :new]
  end
  
  map.resources :groups, :controller => "yogo/groups" do |group|
    group.resource :permission, :controller => "yogo/permissions"
  end
  
  map.resource :user_session, :controller => "yogo/user_sessions"
  
  # map.resources :requirements, :controller => "yogo/requirements",
  #                              :except => [:update, :new, :destroy, :create, :edit],
  #                              :member => { :add_user => :put, :add_no_user => :put, :remove_user  => :put }
  
  map.logout '/logout', :controller => 'yogo/user_sessions', :action => 'destroy'
  map.login '/login', :controller => 'yogo/user_sessions', :action => 'new'
  
end