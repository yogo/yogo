class GroupsController < ApplicationController
  inherit_resources

  protected

  def collection
    @groups ||= resource_class.all
  end

  def resource
    @group ||= resource_class.get(params[:id])
  end
end
