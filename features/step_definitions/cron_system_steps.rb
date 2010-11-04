require 'lib/databasion'

Given /a version spreadsheet in Google Docs/ do
  @config = YAML.load(File.open('config/google.yml'))
end

When /the cron system is ran and the version changes/ do
  Databasion::CronSystem.config = @config
  Databasion::CronSystem.run
end

Then /databasion should have been ran/ do
  Databasion::GoogleLoader.config = @config
  version = Databasion::GoogleLoader.run_version
  File.open(@config['cron']['version']['file']).readline.strip.should == version
  FileUtils.rm_rf @config['cron']['version']['file']
end
