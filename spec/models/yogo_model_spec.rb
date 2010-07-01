require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe "A Yogo Model" do
  
  before(:each) do
    @project = Project.create(:name => "Same Project")

    @properties_hash = {
      "name"    => {:type => String},
      "id"      => {:type => Integer}
    }
  end
  
  after(:each) do
    @project.destroy
  end
  
  it "should be name spaced to the project it was added to" do
    @project.add_model("Cell", @properties_hash)
    Yogo::SameProject::Cell.should_not be_nil
  end
  
  describe "after Yogo::Model is included" do
  
    before(:each) do
      @model = @project.add_model("Cell", @properties_hash)
      @model.send(:include, Yogo::Model)
    end
  
    it "should have a usable_properties method" do
      @model.should respond_to(:usable_properties)
    end
    
    it "should only have 2 usable properties" do
      @model.usable_properties.length.should eql(2)
    end
  
    it "should create models and reflect them back out" do
      project = Project.create(:name => 'Sample', :description => 'This is a test project')

      book = project.add_model("Book")
      author = project.add_model("Author")

      book.property(:name, String, :prefix => 'yogo')
      book.property(:id, Integer, :prefix => 'yogo')
      author.property(:name, String, :prefix => 'yogo')
      author.property(:id, Integer, :prefix => 'yogo')

      book.auto_migrate!
      author.auto_migrate!

      book_schema = book.to_json_schema_hash
      author_schema = author.to_json_schema_hash

      DataMapper::Model.descendants.delete(book)
      DataMapper::Model.descendants.delete(author)

      book = nil
      author = nil

      ns = eval("Yogo::Sample")
      ns.send(:remove_const, :Book)
      ns.send(:remove_const, :Author)

      # Reflect Yogo data into memory
      models = DataMapper::Reflection.reflect(:default)

      models.each{|m| m.send(:include,Yogo::Model) }
      models.each{|m| m.properties.sort! }
      
      models[0].properties.map{|p| p.name }.should include(:yogo__id)

      book_schema.should eql(Yogo::Sample::Book.to_json_schema_hash)
      author_schema.should eql(Yogo::Sample::Author.to_json_schema_hash)    
    end
  
  end
  
  describe "when using associations" do
    
    before(:each) do

    end
    
    it "create models and reflect them back out" do
      project = Project.create(:name => 'Sample', :description => 'This is a test project')
      
      book = project.add_model("Book")
      author = project.add_model("Author")
      
      book.property(:name, String, :prefix => 'yogo')
      author.property(:name, String, :prefix => 'yogo')
      
      book.auto_migrate!
      author.auto_migrate!
      
      book.belongs_to( :author, :prefix => 'yogo__', :model => author )
      author.has(Infinity, :books, :prefix => 'yogo__', :model => book )
      
      book.auto_upgrade!
      author.auto_upgrade!
      
      book_schema = book.to_json_schema_hash
      author_schema = author.to_json_schema_hash
      
      DataMapper::Model.descendants.delete(book)
      DataMapper::Model.descendants.delete(author)
      
      book = nil
      author = nil
      
      ns = eval("Yogo::Sample")
      ns.send(:remove_const, :Book)
      ns.send(:remove_const, :Author)

      # Reflect Yogo data into memory
      models = DataMapper::Reflection.reflect(:default)

      models.each{|m| m.send(:include,Yogo::Model) }
      models.each{|m| m.properties.sort! }

      Yogo::Sample::Author.relationships.keys.should include('yogo__books')
      Yogo::Sample::Author.relationships['yogo__books'].should be_a(DataMapper::Associations::OneToMany::Relationship)
      Yogo::Sample::Book.relationships.keys.should include('yogo__author')
      Yogo::Sample::Book.relationships['yogo__author'].should be_a(DataMapper::Associations::ManyToOne::Relationship)      
      
      book_schema.should eql(Yogo::Sample::Book.to_json_schema_hash)
      author_schema.should eql(Yogo::Sample::Author.to_json_schema_hash)
    end
    
     it "create many to many relationships and reflect them back out" do
        project = Project.create(:name => 'Sample', :description => 'This is a test project')

        book = project.add_model("Book")
        author = project.add_model("Author")

        book.property(:name, String, :prefix => 'yogo')
        author.property(:name, String, :prefix => 'yogo')

        book.auto_migrate!
        author.auto_migrate!

        book.has(Infinity,  :authors, :prefix => 'yogo__', :model => author )
        author.has(Infinity, :books, :prefix => 'yogo__', :model => book )

        book.auto_upgrade!
        author.auto_upgrade!

        book_schema = book.to_json_schema_hash
        author_schema = author.to_json_schema_hash

        DataMapper::Model.descendants.delete(book)
        DataMapper::Model.descendants.delete(author)

        book = nil
        author = nil

        ns = eval("Yogo::Sample")
        ns.send(:remove_const, :Book)
        ns.send(:remove_const, :Author)

        # Reflect Yogo data into memory
        models = DataMapper::Reflection.reflect(:default)

        models.each{|m| m.send(:include,Yogo::Model) }
        models.each{|m| m.properties.sort! }

        Yogo::Sample::Author.relationships.keys.should include('yogo__books')
        Yogo::Sample::Author.relationships['yogo__books'].should be_a(DataMapper::Associations::OneToMany::Relationship)
        Yogo::Sample::Book.relationships.keys.should include('yogo__authors')
        Yogo::Sample::Book.relationships['yogo__authors'].should be_a(DataMapper::Associations::OneToMany::Relationship)      

        book_schema.should eql(Yogo::Sample::Book.to_json_schema_hash)
        author_schema.should eql(Yogo::Sample::Author.to_json_schema_hash)
      end
    
  end
  
end