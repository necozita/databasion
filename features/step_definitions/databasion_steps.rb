require 'lib/databasion'

Given /there is an actual yaml config file for (.*)/ do |name|
  @config = 'config/google.yml'
end

When /the user runs databate for (.*)/ do |name|
  begin
    Databasion.databate(name, @config)
    @error = false
  rescue
    @error = true
  end
end

Then /Databasion should not fail for (.*)/ do |name|
  @error.should == false
end

Given /there is no config file for (.*)/ do |name|
  @config = nil
end

When /the user calls databate without config for (.*)/ do |name|
  begin
    Databasion.databate(name, @config)
    @error = false
  rescue
    @error = true
  end
end

Then /Databasion should fail for (.*)/ do |name|
  @error.should == true
end