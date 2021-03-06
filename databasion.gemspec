# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{databasion}
  s.version = "0.2.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Brian Jones", "Istpika"]
  s.date = %q{2010-12-22}
  s.default_executable = %q{databasion}
  s.email = %q{mojobojo@gmail.com}
  s.executables = ["databasion"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.md"
  ]
  s.files = [
    "CHANGELOG.md",
     "LICENSE",
     "README.md",
     "Rakefile",
     "bin/databasion",
     "config/example.google.yml",
     "databasion.gemspec",
     "features/build_migration.feature",
     "features/create_project.feature",
     "features/cron_system.feature",
     "features/env/helper_methods.rb",
     "features/google_loader.feature",
     "features/step_definitions/build_migration_steps.rb",
     "features/step_definitions/create_project_steps.rb",
     "features/step_definitions/cron_system_steps.rb",
     "features/step_definitions/google_loader_steps.rb",
     "features/step_definitions/yaml_builder_steps.rb",
     "features/yaml_builder.feature",
     "lib/databasion.rb",
     "lib/databasion/application.rb",
     "lib/databasion/build_migration.rb",
     "lib/databasion/cron_system.rb",
     "lib/databasion/git_committer.rb",
     "lib/databasion/google_loader.rb",
     "lib/databasion/load_data.rb",
     "lib/databasion/migrate.rb",
     "lib/databasion/svn_committer.rb",
     "lib/databasion/templates/migration.erb",
     "lib/databasion/templates/model.erb",
     "lib/databasion/yaml_builder.rb",
     "lib/migration_helpers/MIT-LICENSE",
     "lib/migration_helpers/README.markdown",
     "lib/migration_helpers/init.rb",
     "lib/migration_helpers/lib/migration_helper.rb",
     "lib/tasks/databasion.rake",
     "lib/tasks/test.rake",
     "lib/trollop.rb"
  ]
  s.homepage = %q{http://github.com/boj/databasion}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{A Google Spreadsheet/Excel -> YAML -> Ruby Migration Tool}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, [">= 3.0.3"])
      s.add_runtime_dependency(%q<activesupport>, [">= 2.3.5"])
      s.add_runtime_dependency(%q<google-spreadsheet-ruby>, [">= 0.1.2"])
      s.add_runtime_dependency(%q<spreadsheet>, [">= 0.6.4.1"])
      s.add_runtime_dependency(%q<composite_primary_keys>, [">= 3.0.9"])
    else
      s.add_dependency(%q<activerecord>, [">= 3.0.3"])
      s.add_dependency(%q<activesupport>, [">= 2.3.5"])
      s.add_dependency(%q<google-spreadsheet-ruby>, [">= 0.1.2"])
      s.add_dependency(%q<spreadsheet>, [">= 0.6.4.1"])
      s.add_dependency(%q<composite_primary_keys>, [">= 3.0.9"])
    end
  else
    s.add_dependency(%q<activerecord>, [">= 3.0.3"])
    s.add_dependency(%q<activesupport>, [">= 2.3.5"])
    s.add_dependency(%q<google-spreadsheet-ruby>, [">= 0.1.2"])
    s.add_dependency(%q<spreadsheet>, [">= 0.6.4.1"])
    s.add_dependency(%q<composite_primary_keys>, [">= 3.0.9"])
  end
end

