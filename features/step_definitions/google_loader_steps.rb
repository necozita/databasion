require 'lib/databasion'

Given /a google account from the yaml config/ do
  @config = YAML.load(File.open('config/google.yml'))
end

When /GoogleLoader logs in/ do
  Databasion::GoogleLoader.config = @config
  Databasion::GoogleLoader.login
end

Then /we should have a GoogleSpreadsheet session/ do
  Databasion::GoogleLoader.session.should be_kind_of(GoogleSpreadsheet::Session)
end
