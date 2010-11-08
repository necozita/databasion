require 'lib/databasion'

Given /a set of YAML data/ do
  @config = YAML.load(File.open('config/google.yml'))
  @opts = load_opts
  @parse_data = load_parse_data
  Databasion::YamlBuilder.run(@parse_data, @config, @opts)
end

When /we run the BuildMigration system/ do
  Databasion::BuildMigration.run(Dir['%s/%s/**.yml' % [@opts[:env], @config['output']['yaml_path']]], @config, @opts)
end

Then /it should build a migration, model, and database file/ do
  File.exist?('%s/%s/%s/100_%s_migration.rb' % [@opts[:env], @config['output']['migrations']['path'], @parse_data['connection']['dbname'], @parse_data['name']]).should == true
  File.exist?('%s/%s/%s.rb' % [@opts[:env], @config['output']['migrations']['models'], @parse_data['name']]).should == true
  File.exist?('config/database.%s.yml' % @opts[:env]).should == true
  FileUtils.rm_rf @opts[:env]
  FileUtils.rm_rf 'config/database.%s.yml' % @opts[:env]
end
