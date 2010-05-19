require File.join(File.dirname(__FILE__), "../spec_helpers")

module UserSpec
  
  describe User do
    describe "validations" do
      it "should not be valid without a login" do
        Factory.build(:user, :login => nil).should_not be_valid
      end
      
      it "should not be valid without an email" do
        Factory.build(:user, :email => nil).should_not be_valid
      end 
      
      it "should be valid with valid attributes" do
        Factory.build(:user).should be_valid
      end
      
    end
  end
end
