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
      property :id, DataMapper::Types::Serial
      property :name, String
      property :mass, Float
      property :charge, Float
    end

    CsvExampleModel = model if !Object.const_defined?(:CsvExampleModel)
    CsvExampleModel.auto_migrate!
    
    models_path = File.dirname(__FILE__) + '/../models/csv'
    @csv_data = FasterCSV.read(models_path + '/csvtest.csv')
    @bad_csv_data = FasterCSV.read(models_path + '/bad_csvtest.csv')
    @with_blank_lines = FasterCSV.read(models_path + '/with_blank_lines.csv')
    @only_model = FasterCSV.read(models_path + '/only_model.csv')
    @one_line = FasterCSV.read(models_path + '/one_line.csv')
    @updated_csv_data = FasterCSV.read(models_path + '/updated_csv_test.csv')
    @ten_lines = FasterCSV.read(models_path + '/10_lines_of_data.csv')
  end
  
  after(:all) do
    CsvExampleModel.auto_migrate_down!
  end
  
  before(:each) do
    CsvExampleModel.auto_migrate!
  end
  
  describe 'when reading csv data' do
    it 'should validate types are valid in the spreadsheet' do
      result = Yogo::CSV.validate_csv(CsvExampleModel, @csv_data)
      result.should be_true
    end
    
    it "should not validate invalid csv data" do
      result = Yogo::CSV.validate_csv(CsvExampleModel, @bad_csv_data)
      result.should be_false
    end
    
    it "should load data into a model" do
      result = Yogo::CSV.load_data(CsvExampleModel, @csv_data)
      CsvExampleModel.count.should == 3
    end
    
    it "should not load invalid data into a model" do
      result = Yogo::CSV.load_data(CsvExampleModel, @bad_csv_data)
      CsvExampleModel.count.should == 0
    end
    
    it "should ignore blank lines in data lines four and up" do
      result = Yogo::CSV.load_data(CsvExampleModel, @with_blank_lines)
      CsvExampleModel.count.should eql(3)
    end
    
    it "should not have data when just a model is present" do
      Yogo::CSV.load_data(CsvExampleModel, @only_model)
      CsvExampleModel.count.should eql(0)
    end
    
    it "should only load 1 record when there is only 1 record to load" do
      Yogo::CSV.load_data(CsvExampleModel, @one_line)
      CsvExampleModel.count.should eql(1)
      result = CsvExampleModel.first
      result.name.should eql('Sean')
      result.id.should eql(1)
      result.mass.should eql(1283.0)
      result.charge.should eql(1.2)
    end
    
    it "should update existing records with new data" do
      Yogo::CSV.load_data(CsvExampleModel, @csv_data)
      Yogo::CSV.load_data(CsvExampleModel, @updated_csv_data)
      CsvExampleModel.count.should eql(3)
      result = CsvExampleModel.get(1)
      result.name.should eql('Ivan')
      result.mass.should eql(22.0)
      result = CsvExampleModel.get(3)
      result.name.should eql('Dea')
      result.mass.should eql(23.0)
    end
  end
  
  describe "when creating CSV" do
    it "should create a template when asked" do
      Yogo::CSV.load_data(CsvExampleModel, @csv_data)
      result = Yogo::CSV.make_csv(CsvExampleModel, false)
      parsed_result = FasterCSV.parse(result)
      parsed_result.should be_kind_of(Array)
      parsed_result.length.should eql(3)
      
    end
    
    it "should create valid CSV" do
      Yogo::CSV.load_data(CsvExampleModel, @csv_data)
      result = Yogo::CSV.make_csv(CsvExampleModel, true)
      parsed_result = FasterCSV.parse(result)
      parsed_result.should be_kind_of(Array)
      parsed_result.length.should eql(6)
    end
    
    it "should load 10 lines" do
      Yogo::CSV.load_data(CsvExampleModel, @ten_lines)
      CsvExampleModel.count.should eql(10)
    end
    
  end

  
  # describe 'csv file handling' do
  #   describe 'data validation' do
  #     it 'should validate types are valid in the spreadsheet'
  #     it 'should return an error when bad types are used in the spreadsheet'
  #   end
  # 
  #   describe 'data creation' do
  #     it 'should create instances of the model from all valid rows of the spreadsheet'
  #     it 'should warn about invalid instance/row data but continue to create subsequent instances'
  #   end # csv handling
  # end
end