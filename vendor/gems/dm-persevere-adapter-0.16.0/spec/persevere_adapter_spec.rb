require File.dirname(__FILE__) + '/spec_helper'
require DataMapper.root / 'lib' / 'dm-core' / 'spec' / 'adapter_shared_spec'

describe DataMapper::Adapters::PersevereAdapter do
  before :all do
    # This needs to point to a valid persevere server
    @adapter = DataMapper.setup(:default, { :adapter => 'persevere',
                                            :host => 'localhost',
                                            :port => '8080' }
                               )

    @test_schema_hash = {
      'id' => 'Vanilla',
      'properties' => {
        'cid' => {'type' => 'string' },
        'parent' => { 'type' => 'string'},
        'data' => { 'type' => 'string'}
      }
    }
  end

    it_should_behave_like 'An Adapter'

    describe '#get_schema' do
      it 'should return all of the schemas (in json) if no name is provided' do
        @adapter.get_schema()
      end 

      it 'should return the json schema of the class specified' do
        @adapter.get_schema("Object")
      end

      it 'should return all of the schemas (in json) for a project if no name is provided' do
        @adapter.get_schema(nil, "Class")
      end 

      it 'should return all of the schemas (in json) if no name is provided' do
        @adapter.get_schema("Object", "Class")
      end 
    end

    describe '#put_schema' do
      it 'should create the json schema for the hash' do
        @adapter.put_schema(@test_schema_hash)
      end 

      it 'should create the json schema for the hash under the specified project' do
        @adapter.put_schema(@test_schema_hash, "test")
      end

      it 'should create the json schema for the hash under the specified project' do
        @test_schema_hash['id'] = 'test1/Vanilla'
        @adapter.put_schema(@test_schema_hash)
      end 
    end
  end
