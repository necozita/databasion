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
end