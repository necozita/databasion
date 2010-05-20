require 'lib/databasion'

namespace :databasion do
  desc "Run Databasion for Google Spreadsheets"
  task :google do
    Databasion.databate('google', 'config/google.yml')
  end
  
  desc "Run Ruby Migration scripts"
  task :migrate do
    Databasion.databate('migrate', 'config/google.yml')
  end
  
  desc "Run the update script to stuff YAML data into database"
  task :update do
    Databasion.databate('update', 'config/google.yml')
  end
  
  desc "Run the SVN auto-commit system"
  task :svn do
    Databasion.databate('svn', 'config/google.yml')
  end
end