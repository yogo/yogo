require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

#
# This should have all the basic CRUD tests, plus anything the controller is doing special
#
describe YogoDataController do
  describe 'POST' do
  end # POST tests
  
  describe 'GET' do
  end # GET tests
  
  describe 'PUT' do
  end # PUT tests
  
  describe 'DELETE' do
  end # DELETE tests
  
  #
  # At the project level cvs upload means creating a model and instances from a spreadsheet
  # There are a set of tests that should be done on the model creation piece, but
  # the instance creation tests overlap significantly with the yogo_models_controller csv handling.
  # 
  describe 'csv file handling' do
    # Data validation
    it 'should validate types are valid in the spreadsheet'
    it 'should return an error when bad types are used in the spreadsheet'
    # Instance tests
    it 'should create instances of the model from all valid rows of the spreadsheet'
    it 'should warn about invalid instance/row data but continue to create subsequent instances'
  end # csv handling
end # YogoDataController