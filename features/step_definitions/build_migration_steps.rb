require 'lib/databasion'

Given /a set of YAML data/ do
  @config = YAML.load(File.open('config/google.yml'))

  @parse_data = load_parse_data
  Databasion::YamlBuilder.run(@parse_data, @config['output']['yaml_path'])
end

When /we run the BuildMigration system/ do
  Databasion::BuildMigration.run(Dir['%s/**.yml' % @config['output']['yaml_path']], @config)
end

Then /it should build a migration, model, and database file/ do
  File.exist?('%s/%s/100_%s_migration.rb' % [@config['output']['migrations']['path'], @parse_data['connection']['dbname'], @parse_data['name']]).should == true
  File.exist?('%s/%s.rb' % [@config['output']['migrations']['models'], @parse_data['name']]).should == true
  File.exist?('config/database.yml').should == true
  FileUtils.rm_rf @config['output']['migrations']['path']
  FileUtils.rm_rf @config['output']['migrations']['models']
  FileUtils.rm_rf @config['output']['yaml_path']
  FileUtils.rm 'config/database.yml'
end
