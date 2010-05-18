require 'lib/databasion'

Given /a complete set of YAML definitions/ do
  @config = YAML.load(File.open('config/google.yml'))

  @parse_data = {
    'name'        => 'mock',
    'plural'      => true,
    'fields'      => ["id", "name", "power"],
    'types'       => ["integer", "string, 20", "string, 40"],
    'data'        => [[1, "Brian Jones", "Super Intelligence"], [2, "Superman", "Invincible"], [3, "Batman", "Strength"]],
    'ignore_cols' => [2],
    'connection'  => [{'database' => 'moon'}]
  }
  Databasion::Yamalize.yamlbate(@parse_data, @config['output']['yaml_path'])

  #@files = Dir["%s/%s.yml" % [@config['output']['yaml_path'], @parse_data['name']]]
  @files = Dir["%s/*.yml" % @config['output']['yaml_path']]
end

When /the YAML files are parsed/ do
  Databasion::Migitize.migrabate(@files, @config)
end

Then /the result is Ruby migration files/ do
  File.exist?("%s/100_%s.rb" % [@config['output']['migrations']['path'], @parse_data['name']]).should == true
end