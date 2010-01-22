require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

def mock_uploader(file, type = 'text/csv')
  filename = "%s/%s" % [ File.dirname(__FILE__), file ]
  uploader = ActionController::UploadedStringIO.new
  uploader.original_path = filename
  uploader.content_type = type
  def uploader.read
    File.read(original_path)
  end
  def uploader.size
    File.stat(original_path).size
  end
  uploader
end

describe "A Project" do
    
  it "should not be created without a name" do
    count = Project.all.length
    p = Project.new
    p.should_not be_valid   
    p.save
    count.should == Project.all.length
  end

  it "should be created with a name" do
    count = Project.all.length
    p = Factory.create(:project)
    p.should be_valid
    p.save
    count.should == Project.all.length - 1
  end
  
  it "should have a unique name" do
    count = Project.all.length
    p = Factory.create(:project, :name => "A Project")
    p.should be_valid
    q = Factory.build(:project, :name => "A Project")
    q.should_not be_valid
    q.save
    Project.all.length.should == count+1
  end
  
  it "should respond to to_param with the id as a string" do
    p = Project.create(:name => "Test Project")
    p.to_param.should == p.id.to_s
  end
  
  it "should respond to new_record? with its new? value" do
    p = Factory.build(:project)
    p.should be_new
    p.should be_new_record
    p.save
    p.should_not be_new
    p.should_not be_new_record
  end

  it "should be paginated" do
    Project.should respond_to(:page_count)
    Project.should respond_to(:paginate)
  end

  it "should create a model from a csv" do
    p = Project.create(:name => "Ugly Duckling")
    csv = "#{Rails.root}/spec/models/test.csv"
    File.open(csv, "r").should be_true
    model_hash = DataMapper::Reflection::CSV.describe_model(csv)
    p.add_model(model_hash)
    model_name = "Ref" + csv.gsub(/.*\//,'').gsub('.csv','') 
    eval("Yogo::UglyDuckling").const_defined?(model_name).should be_true
    p.destroy!
  end
  
  it "should import data from csv" do
    p = Project.create(:name => "Princess and the Swan")
    csv = "#{Rails.root}/spec/models/test.csv"
    model_hash = DataMapper::Reflection::CSV.describe_model(csv)
    yogo_model = p.add_model(model_hash)
    yogo_model.auto_migrate!
    File.open(csv, "r").should be_true
    DataMapper::Reflection::CSV.import_data_to_model(csv, yogo_model, :yogo)
    model_name = "Ref" + csv.gsub(/.*\//,'').gsub('.csv','')
    yogo_model.first(:name => "Bug").should be_true
    p.destroy!
  end

end