require 'lib/databasion'

Given /an environment spreadsheet in Google Docs/ do
  @config = YAML.load(File.open('config/google.yml'))
  @opts = { :env => 'development' }
end

When /the cron system is ran and the version changes/ do
  Databasion::CronSystem.config = @config
  Databasion::CronSystem.run(@opts)
end

Then /databasion should have been ran/ do
  Databasion::GoogleLoader.config = @config
  version = Databasion::GoogleLoader.run_version(@opts)
  version_file = "%s/version_%s" % [@config['project_base'], @opts[:env]]
  File.open(version_file).readline.strip.should == version
  FileUtils.rm_rf version_file
end
