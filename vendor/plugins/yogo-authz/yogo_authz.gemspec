# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{yogo_authz}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Team Yogo"]
  s.date = %q{2009-07-31}
  s.email = %q{yogo@montana.edu}
  s.extra_rdoc_files = [
    "README"
  ]
  s.files = [
    ".gitignore",
     "CHANGELOG.rdoc",
     "MIT-LICENSE",
     "README",
     "Rakefile",
     "VERSION",
     "app/controllers/yogo_authz/groups_controller.rb",
     "app/controllers/yogo_authz/memberships_controller.rb",
     "app/controllers/yogo_authz/permissions_controller.rb",
     "app/controllers/yogo_authz/user_sessions_controller.rb",
     "app/controllers/yogo_authz/users_controller.rb",
     "app/models/yogo_authz/controller.rb",
     "app/models/yogo_authz/group.rb",
     "app/models/yogo_authz/membership.rb",
     "app/models/yogo_authz/permission.rb",
     "app/models/yogo_authz/user.rb",
     "app/models/yogo_authz/user_session.rb",
     "app/models/yogo_authz/web_user.rb",
     "app/views/yogo_authz/groups/_group_form.html.erb",
     "app/views/yogo_authz/groups/_group_list.html.erb",
     "app/views/yogo_authz/groups/edit.html.erb",
     "app/views/yogo_authz/groups/index.html.erb",
     "app/views/yogo_authz/groups/new.html.erb",
     "app/views/yogo_authz/groups/show.html.erb",
     "app/views/yogo_authz/memberships/show.html.erb",
     "app/views/yogo_authz/permissions/show.html.erb",
     "app/views/yogo_authz/user_sessions/new.html.erb",
     "app/views/yogo_authz/users/_form.html.erb",
     "app/views/yogo_authz/users/edit.html.erb",
     "app/views/yogo_authz/users/index.html.erb",
     "app/views/yogo_authz/users/new.html.erb",
     "app/views/yogo_authz/users/show.html.erb",
     "config/yogo_authz_routes.rb",
     "install.rb",
     "lib/yogo_authz.rb",
     "lib/yogo_authz/authenticated_system.rb",
     "lib/yogo_authz/authorization_system.rb",
     "lib/yogo_authz/controller_helpers.rb",
     "lib/yogo_authz/extensions/routes.rb",
     "lib/yogo_authz/model_authorization_system.rb",
     "rails/init.rb",
     "spec/controllers/groups_controller_spec.rb",
     "spec/db/database.yml",
     "spec/db/schema.rb",
     "spec/models/group_spec.rb",
     "spec/models/user_spec.rb",
     "spec/models/web_user_spec.rb",
     "spec/spec_helpers.rb",
     "spec/spec_opts.rb",
     "spec/yogo_authz_spec.rb",
     "tasks/yogo_authz_tasks.rake",
     "test/test_helper.rb",
     "test/yogo_authz_test.rb",
     "uninstall.rb",
     "yogo_authz.gemspec"
  ]
  s.homepage = %q{http://neurosys.msu.montana.edu/Yogo/index.html}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Autorization and Authenication for the yogo toolkit.}
  s.test_files = [
    "spec/controllers/groups_controller_spec.rb",
     "spec/db/schema.rb",
     "spec/models/group_spec.rb",
     "spec/models/user_spec.rb",
     "spec/models/web_user_spec.rb",
     "spec/spec_helpers.rb",
     "spec/spec_opts.rb",
     "spec/yogo_authz_spec.rb",
     "test/test_helper.rb",
     "test/yogo_authz_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
