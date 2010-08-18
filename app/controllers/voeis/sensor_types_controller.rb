class Voeis::SensorTypesController < Yogo::BaseController
  belongs_to :project, :parent_class => Project, :finder => :get
  respond_to :html, :json
  
end
