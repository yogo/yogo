require File.join(File.dirname(__FILE__), "../spec_helper")

module YogoSettingsSpec
  describe "Settings" do
    
    before(:all) do
      Yogo::Settings.load_defaults(File.dirname(__FILE__)+'/test_settings.yml')
    end
    
    before(:each) do
      Yogo::Settings.send(:reset!)
    end
    
    
    it "should contain values" do
      Yogo::Settings[:first].should == 1
    end
    
    it "should return booleans when booleans are set" do
      Yogo::Settings[:true_boolean].should be_instance_of(TrueClass)
      Yogo::Settings[:false_boolean].should be_instance_of(FalseClass)
    end
    
    it "should overwrite default values" do
      Yogo::Settings[:first].should eql(1)
      Yogo::Settings[:first] = 2
      Yogo::Settings[:first].should eql(2)
    end
    
    it "should should be '1'" do
      Yogo::Settings[:first].should eql(1)
    end
    
    it "should set a new key/value if key/value doesn't exist" do
      Yogo::Settings[:new_key].should eql(nil)
      Yogo::Settings[:new_key] = "New Value"
      Yogo::Settings[:new_key].should eql("New Value")
    end
    
    it "should play nicely with booleans" do
      Yogo::Settings[:new_boolean].should eql(nil)
      Yogo::Settings[:new_boolean] = false
      Yogo::Settings[:new_boolean].should eql(false)
    end
    
    it "should work with strings as keys" do
      Yogo::Settings[:first].should equal(Yogo::Settings['first'])
    end
    
    it "should work with yaml to ruby hashes" do
      Yogo::Settings[:something_nested].should be_instance_of(Hash)
      Yogo::Settings[:something_nested]['first_layer'].should eql('first layer')
    end
  end
end