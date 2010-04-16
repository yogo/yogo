require File.dirname(__FILE__) + '/spec_helper'

describe 'The DataMapper reflection module' do

  describe 'repository(:name).reflect' do
    it 'should reflect all the models in a repository'
  end

  describe 'reflected model instance' do
    it 'should respond to default_repository_name? and return the correct repo for a reflected model'
  end

  describe 'reflective adapter' do
    it 'should respond to get_storage_names and return an array of models' do
      repository(:default).adapter.should respond_to(:get_storage_names)
      repository(:default).adapter.get_storage_names.should be_kind_of(Array)
    end
  end

end
