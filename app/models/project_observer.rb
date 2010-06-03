class ProjectObserver
  include DataMapper::Observer
  
  observe Project
  
  before :save do
    DataMapper.logger.debug { "This is before a save of some sort!" }
  end
  
  before :add_model do
    DataMapper.logger.debug { "This should raise an error." }
  end
  
  before :destroy do
    DataMapper.logger.debug { "Before destroy hook" }
  end
  
  before :delete_model do
    DataMapper.logger.debug { "Before delete_model Hook" }
  end
  
  before :delete_models! do
    DataMapper.logger.debug { "Before delete_models! hook" }
  end
end