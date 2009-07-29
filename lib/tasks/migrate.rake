require 'dm-core'

namespace :db do
  namespace :dm do
    desc "Create all DataMapper Database Tables"
    task :init do
      DataMapper::Model.descendants.each { |model| model.auto_migrate! }
    end
  end
end
