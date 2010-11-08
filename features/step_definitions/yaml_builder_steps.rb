require 'lib/databasion'

Given /a complete set of YAML definitions/ do
  @config = YAML.load(File.open('config/google.yml'))
  @opts = load_opts
  @parse_data = load_parse_data
end

When /the YAML files are parsed/ do
  Databasion::YamlBuilder.run(@parse_data, @config, @opts)
end

Then /the result is Ruby migration files/ do
  path = @opts[:env] + "/" + @config['output']['yaml_path']
  File.exist?("%s/%s.yml" % [path, @parse_data['name']]).should == true
  FileUtils.rm_rf @opts[:env]
end
