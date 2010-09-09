# LabMethods
# 
# This is a "Data Collection Methods"
# The LabMethods table contains descriptions of the laboratory methods used to analyze physical 
# samples for specific constituents. 
# The following rules and best practices should be used when populating this table: 
# * The LabMethodID field is the primary key, must be a unique integer, and cannot be 
# NULL.  It should be implemented as an auto number/identity field. 
# * All of the fields in this table are required and cannot be null except for the 
# LabMethodLink.   
# * The default value for all of the required fields except for the LabMethodID is 
# “Unknown.” 
# * A single record should exist in this table where the LabMethodID = 0 and the LabName, 
# LabOrganization, LabMethdodName, and LabMethodDescription fields are equal to 
# “Unknown” and the LabMethodLink = NULL.  This record should be used to identify 
# samples in the Samples table for which nothing is known about the laboratory method 
# used to analyze the sample. 
# 
class His::LabMethods
  include DataMapper::Resource
  include Odhelper
  
  def self.default_repository_name
    :his_rest
  end
  
  def self.storage_name(repository_name)
    return self.name.gsub(/.+::/, '')
  end
  property :id, Serial, :required => true, :key => true, :field => "LabMethodID"
  property :lab_name, String, :required => true, :default => 'Unknown', :field => "LabName"
  property :lab_organization, String, :required => true, :default => 'Unknown', :field => "LabOrganization"
  property :lab_method_name, String, :required => true, :default => 'Unknown', :field => "LabMethodName"
  property :lab_method_description, String, :required => true, :default => 'Unknown', :field => "LabMethodDescription"
  property :lab_method_link, String, :field => "LabMethodLink"

  has n, :samples, :model => "His::Samples"
  

  validates_with_method :lab_name, :method => :check_lab_name
  def check_lab_name
    check_ws_absence(self.lab_name, "LabName")
  end

  validates_with_method :lab_organization, :method => :check_lab_organization
  def check_lab_organization
    check_ws_absence(self.lab_organization, "LabOrganization")
  end

  validates_with_method :lab_method_name, :method => :check_lab_method_name
  def check_lab_method_name
    check_ws_absence(self.lab_method_name, "LabMethodName")
  end
end