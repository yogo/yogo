require File.join(File.dirname(__FILE__), "../spec_helper")

module YogoSettingsSpec
  describe "Settings" do
    
    before(:all) do
      Yogo::Setting.load_defaults(File.dirname(__FILE__)+'/test_settings.yml')
    end
    
    before(:each) do
      Yogo::Setting.send(:reset!)
    end
    
    
    it "should contain values" do
      Yogo::Setting[:first].should == 1
    end
    
    it "should return booleans when booleans are set" do
      Yogo::Setting[:true_boolean].should be_instance_of(TrueClass)
      Yogo::Setting[:false_boolean].should be_instance_of(FalseClass)
    end
    
    it "should overwrite default values" do
      Yogo::Setting[:first].should eql(1)
      Yogo::Setting[:first] = 2
      Yogo::Setting[:first].should eql(2)
    end
    
    it "should should be '1'" do
      Yogo::Setting[:first].should eql(1)
    end
    
    it "should set a new key/value if key/value doesn't exist" do
      Yogo::Setting[:new_key].should eql(nil)
      Yogo::Setting[:new_key] = "New Value"
      Yogo::Setting[:new_key].should eql("New Value")
    end
    
    it "should play nicely with booleans" do
      Yogo::Setting[:new_boolean].should eql(nil)
      Yogo::Setting[:new_boolean] = false
      Yogo::Setting[:new_boolean].should eql(false)
    end
    
    it "should work with strings as keys" do
      Yogo::Setting[:first].should equal(Yogo::Setting['first'])
    end
    
    it "should work with yaml to ruby hashes" do
      Yogo::Setting[:something_nested].should be_instance_of(Hash)
      Yogo::Setting[:something_nested]['first_layer'].should eql('first layer')
    end
    
    it "should return the keys in the settings" do
      Yogo::Setting.keys.should be_an(Array)
      Yogo::Setting.keys.should_not be_empty
      Yogo::Setting.keys.should include('first')
      Yogo::Setting.keys.should include('something_nested')
    end
  end
end