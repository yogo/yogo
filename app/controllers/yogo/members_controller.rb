class Yogo::MembersController < ApplicationController
  inherit_resources

  defaults :resource_class => Membership, :collection_name => 'memberships', :instance_name => 'membership'

  belongs_to :project, :finder => :get, :parent_class => Project

  respond_to :html, :json
end