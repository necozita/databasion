# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{databasion}
  s.version = "0.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Brian Jones", "Istpika"]
  s.date = %q{2010-05-21}
  s.default_executable = %q{databasion}
  s.email = %q{mojobojo@gmail.com}
  s.executables = ["databasion"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.md"
  ]
  s.files = [
    "LICENSE",
     "README.md",
     "Rakefile",
     "bin/databasion",
     "config/example.google.yml",
     "databasion.gemspec",
     "features/databasion.feature",
     "features/databasion/googlize.feature",
     "features/databasion/migitize.feature",
     "features/databasion/step_definitions/googlize_steps.rb",
     "features/databasion/step_definitions/migitize_steps.rb",
     "features/databasion/step_definitions/svnilize_steps.rb",
     "features/databasion/step_definitions/yamalize_steps.rb",
     "features/databasion/svnilize.feature",
     "features/databasion/yamalize.feature",
     "features/step_definitions/databasion_steps.rb",
     "lib/databasion.rb",
     "lib/databasion/applcize.rb",
     "lib/databasion/csvilize.rb",
     "lib/databasion/datacize.rb",
     "lib/databasion/excelize.rb",
     "lib/databasion/googlize.rb",
     "lib/databasion/loadlize.rb",
     "lib/databasion/migitize.rb",
     "lib/databasion/svnilize.rb",
     "lib/databasion/templates/migration.erb",
     "lib/databasion/templates/model.erb",
     "lib/databasion/yamalize.rb",
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
      s.add_runtime_dependency(%q<activerecord>, [">= 2.3.5"])
      s.add_runtime_dependency(%q<activesupport>, [">= 2.3.5"])
      s.add_runtime_dependency(%q<google-spreadsheet-ruby>, [">= 0.1.1"])
      s.add_runtime_dependency(%q<spreadsheet>, [">= 0.6.4.1"])
    else
      s.add_dependency(%q<activerecord>, [">= 2.3.5"])
      s.add_dependency(%q<activesupport>, [">= 2.3.5"])
      s.add_dependency(%q<google-spreadsheet-ruby>, [">= 0.1.1"])
      s.add_dependency(%q<spreadsheet>, [">= 0.6.4.1"])
    end
  else
    s.add_dependency(%q<activerecord>, [">= 2.3.5"])
    s.add_dependency(%q<activesupport>, [">= 2.3.5"])
    s.add_dependency(%q<google-spreadsheet-ruby>, [">= 0.1.1"])
    s.add_dependency(%q<spreadsheet>, [">= 0.6.4.1"])
  end
end

