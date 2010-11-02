require 'lib/databasion'

Given /a complete set of YAML definitions/ do
  @config = YAML.load(File.open('config/google.yml'))

  @parse_data = load_parse_data
end

When /the YAML files are parsed/ do
  Databasion::YamlBuilder.run(@parse_data, @config['output']['yaml_path'])
end

Then /the result is Ruby migration files/ do
  File.exist?("%s/%s.yml" % [@config['output']['yaml_path'], @parse_data['name']]).should == true
  FileUtils.rm_rf @config['output']['yaml_path']
end
