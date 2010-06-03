require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe Group do
  
  before(:each) do
    User.all.destroy
    Group.all.destroy
  end
  
  it "should persist to the database" do
    group = standard_group
    group.save
    
    group.should be_valid
    Group.count.should eql 1
  end
  
  
  def standard_group
    Group.new(:name => 'A Group')
  end
end