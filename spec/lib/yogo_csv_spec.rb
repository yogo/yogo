require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe 'Yogo CSV Module' do
  #
  # At the project level cvs upload means creating a model and instances from a spreadsheet
  # There are a set of tests that should be done on the model creation piece, but
  # the instance creation tests overlap significantly with the yogo_models_controller csv handling.
  # 
  
  before(:all) do
    # Need a model and a CSV file.
    model = DataMapper::Model.new do
      include Yogo::Model
      property :yogo_id, DataMapper::Types::Serial, :field => 'id'
      property :id,   Integer,  :prefix => 'yogo'
      property :name, DataMapper::Types::Text,  :prefix => 'yogo'
      property :mass, Float,   :prefix => 'yogo'
      property :charge, Float, :prefix => 'yogo'
      property :private_field, String
    end

    CsvExampleModel = model if !Object.const_defined?(:CsvExampleModel)
    CsvExampleModel.auto_migrate!
    # CsvExampleModel.send(:include, Yogo::Model)
    
    models_path       = File.dirname(__FILE__) + '/../models/csv'
    @csv_data         = models_path + '/csvtest.csv'
    @bad_data         = models_path + '/bad_data.csv'
    @bad_csv_data     = models_path + '/bad_csvtest.csv'
    @with_blank_lines = models_path + '/with_blank_lines.csv'
    @only_model       = models_path + '/only_model.csv'
    @one_line         = models_path + '/one_line.csv'
    @updated_csv_data = models_path + '/updated_csv_test.csv'
    @ten_lines        = models_path + '/10_lines_of_data.csv'
    @new_properties   = models_path + '/new_properties.csv'
  end
  
  after(:all) do
    CsvExampleModel.auto_migrate_down!
  end
  
  before(:each) do
    CsvExampleModel.auto_migrate!
  end
  
  describe "when creating CSVs" do
    
    before(:each) do
      CsvExampleModel.auto_migrate!
    end
    
    it "should respond to to_csv" do
      CsvExampleModel.should respond_to(:to_csv)
    end
    
    it "should return valid CSV model headers when asked" do
      csv = CsvExampleModel.to_csv
      csv.should be_kind_of(String)
      result = FasterCSV.parse(csv)
      result.length.should eql(3)
      result[0].length.should eql(CsvExampleModel.properties.length)
    end
    
    it "should respond to to_yogo_csv" do
      CsvExampleModel.should respond_to(:to_yogo_csv)
    end
    
    it "should return valid yogo CSV model headers when asked" do
      csv = CsvExampleModel.to_yogo_csv
      csv.should be_kind_of(String)
      result = FasterCSV.parse(csv)
      result.length.should eql(3)
      result[0].length.should eql(CsvExampleModel.usable_properties.length + 1)
    end
    
  end
  
  describe 'when loading csv data' do
    
    before(:each) do
      CsvExampleModel.auto_migrate!
    end
    
    it 'should load valid csv data' do
      result = CsvExampleModel.load_csv_data(@csv_data)
      result.should be_empty
      result.should_not be_false
    end
    
    it "should not validate invalid csv data" do
      result = CsvExampleModel.load_csv_data(@bad_csv_data)
      result.should be_kind_of(Array)
      result.should_not be_empty
      result.first.should eql("The datatype bozon for the ID column is invalid.")
    end
    
    it "should load data into a model" do
      result = CsvExampleModel.load_csv_data(@csv_data)
      result.should be_empty
      CsvExampleModel.count.should == 3
    end
    
    it "should not load invalid data into a model" do
      result = CsvExampleModel.load_csv_data(@bad_csv_data)
      result.should_not be_empty
      CsvExampleModel.count.should == 0
    end
    
    it "should ignore blank lines in data lines four and up" do
      result = CsvExampleModel.load_csv_data(@with_blank_lines)
      result.should be_empty
      # debugger if CsvExampleModel.count == 0
      CsvExampleModel.count.should eql(3)
    end
    
    it "should not have data when just a model is present" do
      CsvExampleModel.load_csv_data(@only_model)
      CsvExampleModel.count.should eql(0)
    end
    
    it "should only load 1 record when there is only 1 record to load" do
      CsvExampleModel.load_csv_data(@one_line)
      CsvExampleModel.count.should eql(1)
      result = CsvExampleModel.first
      result.yogo__name.should eql('Sean')
      result.yogo__id.should eql(1)
      result.yogo__mass.should eql(1283.0)
      result.yogo__charge.should eql(1.2)
    end
    
    it "should update existing records with new data" do
      CsvExampleModel.load_csv_data(@csv_data)
      errors = CsvExampleModel.load_csv_data(@updated_csv_data)
      errors.should be_empty
      CsvExampleModel.count.should eql(3)
      result = CsvExampleModel.get(1)
      result.yogo__name.should eql('Ivan')
      result.yogo__mass.should eql(22.0)
      result = CsvExampleModel.get(3)
      result.yogo__name.should eql('Dea')
      result.yogo__mass.should eql(23.0)
    end
    
    it "should not load bad data" do
      errors = CsvExampleModel.load_csv_data(@bad_data)
      errors.should_not be_empty

      CsvExampleModel.count.should eql(0)
    end
    
    it "should load 10 lines" do
      result = CsvExampleModel.load_csv_data(@ten_lines)
      result.should be_empty
      CsvExampleModel.count.should eql(10)
    end
    
    it "should add new properties to the model" do
      CsvExampleModel.load_csv_data(@csv_data)
      CsvExampleModel.usable_properties.length.should eql(4)
      CsvExampleModel.properties.length.should eql(6)
      CsvExampleModel.load_csv_data(@new_properties)
      CsvExampleModel.usable_properties.length.should eql(5)
      CsvExampleModel.properties.length.should eql(7)
    end
    
    it "should load images and files"
    
  end

end