require File.dirname(__FILE__) + '/spec_helper'

describe 'The DataMapper reflection module' do

  describe 'repository(:name).reflect' do 
    it 'should reflect all the models in a repository'
  end
  
  describe 'reflected model instance' do   
    # it 'should respond to is_reflected? and return true for a reflected model' 
    it 'should respond to default_repository_name? and return the correct repo for a reflected model'
  end
  
  describe 'persevere adapter' do
    it 'should respond to fetch_storage_names and return an array of models'
  end
  
  describe 'mysql adapter' do
    it 'should respond to fetch_storage_names and return an array of models'
  end
  
  describe 'sqlite3 adapter' do
    it 'should respond to fetch_storage_names and return an array of models'
  end
  
  describe 'postgres adapter' do
    it 'should respond to fetch_storage_names and return an array of models'
  end
  
  describe 'csv utilities' do
    it 'should parse the first three lines of a well formatted csv file, create and return a model'
    it 'should parse the remaining lines of a well formatted csv file and create instances of the model'
  end
end