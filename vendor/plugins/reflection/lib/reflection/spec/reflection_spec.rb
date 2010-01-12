require File.dirname(__FILE__) + '/spec_helper'



describe 'Reflection' do 
  before(:all) do 
    @simple_json_schema = <<-EOF
    { "id":"Cell",
      "properties":{
        "name":{
            "type":"string"
        }
      }
    }
    EOF
    @simple_json_schema_hash = 
    { "id" => "Cell",
      "properties" => {
        "name" => {
            "type" => "string"
        }
      }
    }
    @nested_json_schema = <<-EOF
    { "id":"KefedModel",
      "properties":{
        "nodes":{
          "properties":{
            "i_vars":{},
            "d_vars":{},
            "objects":{},
            "actions":{},
            "branches":{
              "optional":true
            },
            "conditionals":{
              "optional":true
            }
          }
        },
        "edges":{}
      }
    }
    EOF
    @nested_json_schema_hash =
    { "id" => "KefedModel",
      "properties" => {
        "nodes" => {
          "properties" => {
            "i_vars" => {},
            "d_vars" => {},
            "objects" => {},
            "actions" => {},
            "branches" => {
              "optional" => true
            },
            "conditionals" => {
              "optional" => true
            }
          }
        },
        "edges" => {}
      }
    }
    @namspaced_json_schema = <<-EOF
    { "id":"Project1/Cell",
      "properties":{
        "name":{
            "type":"string"
        }
      }
    }
    EOF
    @lower_case_json_schema = <<-EOF
    {"id":"items",
      "properties":{
        "data":{
          "type":"string"
        },
        "image_id":{
          "type":"integer"
        },
        "price":{
          "type":"number"
        },
        "name":{
          "type":"string"
        }
      }
    }
    EOF
    
    @lower_case_namespaced_json_schema = <<-EOF
    {"id":"example_project/items",
      "properties":{
        "data":{
          "type":"string"
        },
        "image_id":{
          "type":"integer"
        },
        "price":{
          "type":"number"
        },
        "name":{
          "type":"string"
        }
      }
    }
    EOF
  end
  
  it 'should retrieve namespaced schemas for a simple schema' do
    Project1.name.should == 'Project1'
    repository(:persevere).adapter.put_schema(@simple_json_schema_hash, Project1.name)
    json = repository(:persevere).adapter.get_schema('Cell', Project1.name)
    ref_model = DataMapper::Reflection.create_model_from_json(json, Project1)[0]
    ref_model.class.should == DataMapper::Property
    ref_model.model.should == Project1::Cell
    #destroy schemas
  end
  it 'should retrieve namespaced schemas for a nested schema' do
    Project1.name.should == 'Project1'
    repository(:persevere).adapter.put_schema(@nested_json_schema_hash, Project1.name)
    json = repository(:persevere).adapter.get_schema('KefedModel', Project1.name)
    ref_models = DataMapper::Reflection.create_model_from_json(json, Project1)
    ref_models.length.should == 2
    ref_models.each do |m|
      m.class.should == DataMapper::Property
    end
    [Project1::KefedModel, Project1::KefedmodelNode].each do |m|
      ref_models.map(&:model).should be_include(m)
    end
  end
  
  it "should create a virtual model of all models in the database" do
    DataMapper::Reflection.create_all_models_from_database
  end
  
  describe "a reflected model" do
   
    before(:all) do 
      @simple_json_schema = <<-EOF
      { "id":"Cell",
        "properties":{
          "name":{
              "type":"string"
          }
        }
      }
      EOF
    end
    
    it "should respond to is_reflected? and return true for a reflected model" do
      DataMapper::Reflection.create_model_from_json(@simple_json_schema)
      Cell.should respond_to(:is_reflected?)
      Cell.is_reflected?.should equal(true)
    end
    it "should respond to default_repository_name? and return the correct repo for a reflected model" do
      DataMapper::Reflection.create_model_from_json(@simple_json_schema)
      Cell.should respond_to(:default_repository_name)
      Cell.default_repository_name.should equal(:persevere)
    end
  end
  
end