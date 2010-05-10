# Yogo Authorization Module
# Copyright (c) 2009 Montana State University
#
# FILE: user_session.rb
# AuthLogic's user session object.
class Yogo::UserSession < Authlogic::Session::Base
  # specify configuration here such as:
  # logout_on_timeout true
  # ... See the authlogic doc.
  
  # TODO: Make this configurable from somewhere else.
  # Users shouldn't have to touch this plug in to make it work.
  
  authenticate_with User
  find_by_login_method :find_by_login


  if Yogo::Settings[:allow_api_key] == true
    params_key Yogo::Settings[:api_key_name]
  end

  ## Should be commented out for right now.
  # ldap_host 'ds.montana.edu'
  # ldap_port 636
  # ldap_login_format 'uid=%s,ou=People,dc=montana,dc=edu'
  # find_by_ldap_login_method :find_by_ldap_login
  # ldap_use_encryption true
  # ldap_create_in_database true
  # ldap_search_base 'ou=People,dc=montana,dc=edu'
  # 
  # ldap_login_field :login
  # ldap_password_field :password
  # 
  # ldap_search_local_database_first true
  # find_by_login_method :find_by_login
end