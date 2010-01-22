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
    file_name = "#{Rails.root}/spec/models/csvtest.csv"
    
    # Get Model name
    model_name = File.basename(file_name, ".csv").camelcase
    
    # Process the contents
    csv_data = FasterCSV.read(file_name)

    model = DataMapper::Factory.make_model_from_csv(model_name, csv_data[0..2])
    # csv_data[3..-1].each do |line| 
    #   line_data = Hash.new
    #   csv_data[0].each_index { |i| line_data[cvs_data[0][i]] = line[i] }
    #   model.create(line_data)
    # end

    Object.const_defined?(model_name).should be_true
  end
  
  it "should import data from csv" do
    file_name = "#{Rails.root}/spec/models/csvtest.csv"
    
    # Get Model name
    model_name = File.basename(file_name, ".csv").camelcase
    
    # Process the contents
    csv_data = FasterCSV.read(file_name)
    model = DataMapper::Factory.make_model_from_csv(model_name, csv_data[0..2])
    model.auto_migrate!
    csv_data[3..-1].each do |line| 
      line_data = Hash.new
      csv_data[0].each_index { |i| line_data[csv_data[0][i].downcase] = line[i] }
      model.create(line_data)
    end

    model.first(:name => "Bug").should be_true
    model.auto_migrate_down!
  end

end