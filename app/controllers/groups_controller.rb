class GroupsController < ApplicationController
  inherit_resources

  # def update
  #   super do |format|
  #     format.html { redirect_to(groups_url) }
  #   end
  # end

  def create
    super do |format|
      format.html { redirect_to(groups_url) }
    end
  end
  #
  # def delete
  #   super do |format|
  #     format.html { redirect_to(groups_url) }
  #   end
  # end

  protected

  def collection
    @groups ||= resource_class.all
  end

  def resource
    @group ||= resource_class.get(params[:id])
  end
end
