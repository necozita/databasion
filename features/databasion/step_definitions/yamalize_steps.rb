require 'lib/databasion'

Given /a chunk of (.*) data/ do |name|
  @config = YAML.load(File.open('config/google.yml'))
  @parse_data = {
    'name'        => 'mock',
    'plural'      => true,
    'fields'      => ["id", "name", "power"],
    'types'       => ["integer", "string, 20", "string, 40"],
    'data'        => [[1, "Brian Jones", "Super Intelligence"], [2, "Superman", "Invincible"], [3, "Batman", "Strength"]],
    'ignore_cols' => [2],
    'connection'  => []
  }
end

When /we parse it/ do
  Databasion::Yamalize.yamlbate(@parse_data, @config['output']['yaml_path'])
end

Then /it should create a relevant YAML file/ do
  File.exist?("%s/%s.yml" % [@config['output']['yaml_path'], @parse_data['name']]).should == true
end

And /should contain the correct data/ do
  data = YAML.load(File.open("%s/%s.yml" % [@config['output']['yaml_path'], @parse_data['name']]))
  data.should include('meta')
  data.should include('data')
  data['meta'].should include('connection')
end