namespace :reflect do
  desc "Configure navigation settings."
  task :view => :environment do
    view = []
    DataMapper::Reflection.adapter.fetch_models.each do |model|
      view << DataMapper::Reflection.describe_class(DataMapper::Reflection::DBReflect.describe_model(model))
    end
    puts "<----------DESCRIPTIONS---------->"
    puts view.join("\n\n")  
    puts "<--------------END--------------->"
  end
  
end