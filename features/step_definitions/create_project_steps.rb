Given /a project named (.*)/ do |project_name|
  @project = project_name
end

When /the databasion create command is ran/ do
  system 'bin/databasion -c %s' % @project
end

Then /a project folder and config file should exist/ do
  File.exists?('%s' % @project).should == true
  File.exists?('%s/config/google.yml' % @project).should == true
  FileUtils.rm_rf '%s/' % @project
end
