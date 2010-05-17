require 'lib/databasion'

Given /a complete set of YAML definitions/ do
  @config = YAML.load(File.open('config/google.yml'))

  @parse_data = {
    'name'        => 'mock',
    'fields'      => ["id", "name", "power"],
    'types'       => ["unsigned int", "varchar(20)", "varchar(40)"],
    'data'        => [[1, "Brian Jones", "Super Intelligence"], [2, "Superman", "Invincible"], [3, "Batman", "Strength"]],
    'ignore_cols' => [2]
  }
  Databasion::Yamalize.yamlbate(@parse_data, @config['output']['yaml_path'])

  @files = Dir["%s/%s.yml" % [@config['output']['yaml_path'], @parse_data['name']]]
end

When /the YAML files are parsed/ do
  Databasion::Migitize.migrabate(@files, @config)
end

Then /the result is Ruby migration files/ do
  File.exist?("%s/100_%s.rb" % [@config['output']['migration_path'], @parse_data['name']]).should == true
end