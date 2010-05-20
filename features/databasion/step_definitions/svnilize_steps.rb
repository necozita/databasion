require 'lib/databasion'

Given /a databasion created file structure/ do
  Databasion::Applcize.create_project({ :create => 'cucumber_test' })
end

When /the commit command is ran/ do
  Databasion::Svnilize.commit('cucumber_test')
end

Then /the data should be stored in SVN/ do

  FileUtils.rm_rf 'cucumber_test'
end