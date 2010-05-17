require 'lib/databasion'

Given /a google account/ do
  @config = YAML.load(File.open('config/google.yml'))
end

When /Googlize logs in/ do
  Databasion::Googlize.config = @config
  Databasion::Googlize.login
end

Then /we should have a GoogleSpreadsheet session/ do
  Databasion::Googlize.session.should be_kind_of(GoogleSpreadsheet::Session)
end

Given /a google yaml config/ do
  @config = YAML.load(File.open('config/google.yml'))
end

When /Googlize starts up/ do
  Databasion::Googlize.config = @config
  begin
    Databasion::Googlize.googlebate
    @error = false
  rescue
    @error = true
  end
end

Then /Googlize should not fail/ do
  @error.should == false
end