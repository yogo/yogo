require File.join(File.dirname(__FILE__), "../spec_helper")

module YogoSettingsSpec
  describe "Settings" do

    before(:all) do
      Setting.load_defaults(File.dirname(__FILE__)+'/test_settings.yml')
    end

    before(:each) do
      Setting.send(:reset!)
    end


    it "should contain values" do
      Setting[:first].should == 1
    end

    it "should return booleans when booleans are set" do
      Setting[:true_boolean].should be_instance_of(TrueClass)
      Setting[:false_boolean].should be_instance_of(FalseClass)
    end

    it "should overwrite default values" do
      Setting[:first].should eql(1)
      Setting[:first] = 2
      Setting[:first].should eql(2)
    end

    it "should should be '1'" do
      Setting[:first].should eql(1)
    end

    it "should set a new key/value if key/value doesn't exist" do
      Setting[:new_key].should eql(nil)
      Setting[:new_key] = "New Value"
      Setting[:new_key].should eql("New Value")
    end

    it "should play nicely with booleans" do
      Setting[:new_boolean].should eql(nil)
      Setting[:new_boolean] = false
      Setting[:new_boolean].should eql(false)
    end

    it "should work with strings as keys" do
      Setting[:first].should equal(Setting['first'])
    end

    it "should work with yaml to ruby hashes" do
      Setting[:something_nested].should be_instance_of(Hash)
      Setting[:something_nested]['first_layer'].should eql('first layer')
    end

    it "should return the keys in the settings" do
      Setting.names.should be_an(Array)
      Setting.names.should_not be_empty
      Setting.names.should include('first')
      Setting.names.should include('something_nested')
    end
  end
end