# GeneralCategoryCV
#
# The GeneralCategory CV table contains the controlled vocabulary for the GeneralCategory field in
# the Variable model
#
class GeneralCategoryCV
  include DataMapper::Resource
  
  property :term,       String, :required => true, :key => true, :format => /[^\t|\n|\r]/
  property :definition, Text
  property :updated_at, DateTime, :required => true,  :default => DateTime.now

  is_versioned :on => :updated_at
  
  before(:save) {
    self.updated_at = DateTime.now
  }
  has n,   :variables, :model => "Variable", :through => Resource
  
  
  def self.load_from_his
    his_general_categorys = His::GeneralCategoryCV.all

    his_general_categorys.each do |his_gc|
        self.first_or_create(
                    :term => his_gc.term,
                    :definition=> his_gc.definition)
      
    end
  end

  def store_to_his(u_id)
    gen_cat_to_store = self.first(:id => u_id)
    if gen_cat_to_store.is_regular == true
      reg = 1
    else
      reg =0
    end
    new_his_gen_cat = His::GeneralCategoryCV.new(:term => gen_cat_to_store.term,
                                        :definition => gen_cat_to_store.definition)
    new_his_gen_cat.save
    puts new_his_gen_cat.errors.inspect
    gen_cat_to_store.his_id = new_his_gen_cat.id
    gen_cat_to_store.save
    new_his_gen_cat
  end
end
