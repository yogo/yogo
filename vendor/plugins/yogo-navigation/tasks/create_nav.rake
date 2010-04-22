namespace :navigation do
  namespace :db do
    desc "Configure navigation settings."
    task :load => :environment do
      models = (DataMapper::Model.descendants.to_ary - [NavModel, NavAttribute, NavDisplayValue, NavDatabaseValue, DataMapperStore::Session])
      models.each do |x|
        nav_model = NavModel.new(:name          => x.name,
                                 :display       => true,
                                 :model_id      => x.name.split('::')[-1],
                                 :display_name  => x.name.split('::')[-1],
                                 :display_count => false
                                 )
        x.properties.each do |y|
          nav_attribute = NavAttribute.new(:name          => y.name,
                                           :display       => true,
                                           :display_name  => y.name,
                                           :display_count => false,
                                           :range         => false
                                           )
         nav_model.nav_attributes << nav_attribute
         nav_model.save
       end
     end
   end
 end
end
