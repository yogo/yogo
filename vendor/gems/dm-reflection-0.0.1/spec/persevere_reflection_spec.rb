require File.dirname(__FILE__) + '/spec_helper'
require 'mock_persevere_adapter'

describe 'The Persevere DataMapper reflection module' do
  
  before(:all) do
    @adapter = MockPersevereAdapter.new
  end
  
  it "should return an array of tables" do
    @adapter.get_storage_names.should be_kind_of(Array)
  end
  
  it "should return a table definition" do
    result = @adapter.get_properties('boots')
    result.should be_kind_of(Array)
  end
  
  it "should description" do
    
  end

end