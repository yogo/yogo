describe 'Yogo CSV Module' do
  #
  # At the project level cvs upload means creating a model and instances from a spreadsheet
  # There are a set of tests that should be done on the model creation piece, but
  # the instance creation tests overlap significantly with the yogo_models_controller csv handling.
  # 
  
  before(:all) do
    # Need a model and a CSV file.
    @model = DataMapper::Model.new do
      property :id, DataMapper::Types::Serial
      property :name, String
      property :mass, Float
      property :charge, Float
    end
    
    CsvExampleModel = @model
    @model.auto_migrate!
    
    models_path = File.dirname(__FILE__) + '/../models'
    @csv_data = FasterCSV.read(models_path + '/csvtest.csv')
    @bad_csv_data = FasterCSV.read(models_path + '/bad_csvtest.csv')
  end
  
  after(:all) do
    @model.auto_migrate_down!
  end
  
  before(:each) do
    @model.auto_migrate!
  end
  
  describe 'when reading csv data' do
    it 'should validate types are valid in the spreadsheet' do
      result = Yogo::CSV.validate_csv(@model, @csv_data)
      result.should be_true
    end
    
    it "should not validate invalid csv data" do
      result = Yogo::CSV.validate_csv(@model, @bad_csv_data)
      result.should be_false
    end
    
    it "should load data into a model" do
      result = Yogo::CSV.load_data(@model, @csv_data)
      @model.count.should be(3)
    end
    
    it "should not load invalid data into a model" do
      result = Yogo::CSV.load_data(@model, @bad_csv_data)
      @model.count.should be(2)
    end
  end

  describe "when creating CSV" do
    it "should create a template when asked" do
      Yogo::CSV.load_data(@model, @csv_data)
      result = Yogo::CSV.make_csv(@model, false)
      parsed_result = FasterCSV.parse(result)
      parsed_result.should be_kind_of(Array)
      parsed_result.length.should eql(3)
      
    end
    
    it "should create valid CSV" do
      Yogo::CSV.load_data(@model, @csv_data)
      result = Yogo::CSV.make_csv(@model, true)
      parsed_result = FasterCSV.parse(result)
      parsed_result.should be_kind_of(Array)
      parsed_result.length.should eql(6)
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