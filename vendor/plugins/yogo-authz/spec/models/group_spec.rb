require File.join(File.dirname(__FILE__), "../spec_helpers")

module GroupSpec
  describe "group" do

    # before(:all) do
    #   puts "sets stuff up before running this file"
    # end
    # 
    # before(:each) do
    #   puts "setting stuff up before each test"
    # end

    it "should do something" do
      group = Yogo::Group.create(:name => "Test Group")
      group.name.should == "Test Group"
    end

    it "Should be empty" do
      
    end
    
    it "should not save" do
      group = Yogo::Group.new
      group.valid?.should == false
    end
    
    # after(:each) do
    #   puts "runs after each test"
    # end
  end  
end

