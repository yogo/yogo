class ProjectObserver
  include DataMapper::Observer
  
  observe Project
  
  before :add_model do
    raise AuthorizationError, "You can't do that!"
  end
  
  before :destroy do
    raise AuthorizationError, "You can't do that!"
  end
  
  before :delete_model do
    raise AuthorizationError, "You can't do that!"
  end
  
  before :delete_models! do
    raise AuthorizationError, "You can't do that!"
  end
end