require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe User do
  
  before :each do
    User.current = nil
    User.all.destroy
    Group.all.destroy
    Project.all.destroy
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
    u = standard_user
    login = u.login
    u.save
    
    u = User.find_by_login(login)
    u.should_not be_nil
    u.should_not eql false
    u.should be_kind_of(User)
    
    u.login.should eql(login)
    u.destroy
  end
  
  it "should enforce unique logins" do
    u = standard_user.save
    lambda do
      u2 = standard_user

      u2.should_not be_valid
      u2.errors.keys.should eql 1
      u2.errors.should have_key(:login)
      u2.save
    end.should_not change(User, :count)
    
  end
  
  it "should should validate passwords" do
    u = standard_user
    login = u.login
    u.save
    u = User.find_by_login(login)

    (u.crypted_password == 'pass').should eql(true)
    (u.crypted_password == 'bad_pass').should eql(false)
    "#{u.crypted_password}".should_not eql('pass')
  end
  
  it "should belong to certain groups" do
    u = standard_user
    login = u.login
    u.save
    
    g = standard_group
    group_name = g.name
    g.save
    
    u.groups << g
    u.save

    User.first.has_group?(group_name).should eql(true)
    Group.first.users.first.login.should eql(login)
  end
  
  it "should belong to certain projects" do
    u = standard_user
    u.save
    User.current = u
    
    p = Project.create(:name => 'blah')

    u.is_in_project?(p).should be_true
  end
  
  it "should not belong to some projects" do
    p = Project.create(:name => 'some project')
    u = standard_user
    u.save

    u.is_in_project?(p).should be_false
  end

  ## OH WOW. This shows brokenness.
  it "should allow many users to belong to many groups" do
    u1 = standard_user(:login => 'login1')
    u2 = standard_user(:login => 'login2')
    u1.save
    u2.save
    
    g = Group.create(:name => 'Administrators', :admin => true)
    
    Group.first.should eql g
    u1.groups << g
    u1.save
    
    Group.first.users.length.should eql 1
 
    Group.first.users.first.id.should eql u1.id
    Group.first.users.first.login.should eql u1.login
    
    User.get(u1.id).groups.length.should eql 1

    u = User.get(u2.id)
    gr = Group.first
    u.groups << gr
    u.save
    
    u3 = standard_user(:login => 'thrid')
    u3.groups << g
    u3.save

    Group.first.users.length.should eql 3
    Group.first.users.first.id.should eql u1.id
    Group.first.users.first.login.should eql u1.login
    
    # Group.first.users[1].id.should eql u2.id
    # Group.first.users[1].login.should eql u2.login
    
    User.get(u1.id).groups.length.should eql 1
    User.get(u2.id).groups.length.should eql 1
    User.get(u3.id).groups.length.should eql 1
  end

end