require 'lib/databasion'

namespace :databasion do
  desc "Run Databasion for Google Spreadsheets"
  task :google do
    Databasion.run('google', 'config/google.yml')
  end
  
  desc "Run Ruby Migration scripts"
  task :migrate do
    Databasion.run('migrate', 'config/google.yml')
  end
  
  desc "Run the load script to stuff YAML data into database"
  task :load do
    Databasion.run('load', 'config/google.yml')
  end
  
  desc "Run the SVN auto-commit system"
  task :svn do
    Databasion.run('svn', 'config/google.yml')
  end
  
  desc "Run the GIT auto-commit system"
  task :git do
    Databasion.run('git', 'config/google.yml')
  end
end