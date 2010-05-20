require 'rubygems'
require 'rake'
require 'jeweler'

Jeweler::Tasks.new do |gem|
  gem.name        = "databasion"
  gem.summary     = %Q{A Google Spreadsheet/Excel -> YAML -> Ruby Migration Tool}
  gem.email       = "mojobojo@gmail.com"
  gem.homepage    = "http://github.com/boj/databasion"
  gem.authors     = ["Brian Jones", "Istpika"]
  gem.version     = "0.0.2"

  gem.add_dependency('activerecord', '>= 2.3.5')
  gem.add_dependency('activesupport', '>= 2.3.5')
  gem.add_dependency('google-spreadsheet-ruby', '>= 0.1.1')
  gem.add_dependency('spreadsheet', '>= 0.6.4.1')
end

Jeweler::GemcutterTasks.new

Dir['lib/tasks/**/*.rake'].each { |rake| load rake }

task :default  => :test
