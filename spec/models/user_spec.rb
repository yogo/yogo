require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe User do
  
  before :each do
    User.all.destroy
    Group.all.destroy
  end
  
  it "should have a login" do
    u = standard_user
    u.should be_valid
  end
  
  it "should have a password and password confirmation" do
    u = standard_user(:password => 'first pass', :password_confirmation => 'second pass')
    u.save.should eql false
    u.should_not be_valid
  end
  
  it "should do a search by login" do
    standard_user.save
    u = User.find_by_login('robbie')
    u.should_not be_nil
    u.should_not eql false
    u.should be_kind_of(User)
    
    u.login.should eql('robbie')
    u.destroy
  end
  
  it "should enforce unique logins" do
    u = standard_user.save
    u2 = standard_user

    u2.should_not be_valid    
    u2.errors.should have(1).error
    u2.errors.should have_key(:login)
  end
  
  it "should should validate passwords" do
    standard_user.save
    u = User.find_by_login('robbie')

    (u.crypted_password == 'pass').should eql(true)
    (u.crypted_password == 'bad_pass').should eql(false)
    "#{u.crypted_password}".should_not eql('pass')
  end
  
  it "should belong to certain groups" do
    u = standard_user
    u.save
    
    g = standard_group
    g.save
    
    u.groups << g
    u.save
    
    User.first.has_group?(:super).should eql(true)
    
    Group.first.users.first.login.should eql('robbie')
    
  end
  
  def standard_user(opts = {})
    User.new({:login => 'robbie', :password => "pass", :password_confirmation => 'pass'}.merge(opts))
  end
  
  def standard_group(opts = {})
    Group.new({:name => 'super'}.merge(opts))
  end
end