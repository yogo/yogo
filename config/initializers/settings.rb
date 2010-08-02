##
# Set default settings

Setting.first_or_create(:name => 'local_only', :value => false)
Setting.first_or_create(:name => 'hide_example_project', :value => true)
Setting.first_or_create(:name => 'require_change_summary', :value => true)
Setting.first_or_create(:name => 'asset_directory', :value => 'yogo_assets')
Setting.first_or_create(:name => 'anonymous_user_name', :value => 'anonymous')
Setting.first_or_create(:name => 'allow_api_key', :value => true)
Setting.first_or_create(:name => 'api_key_name', :value => 'api_key')