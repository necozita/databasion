require 'rubygems'

APP_PATH = File.dirname(File.expand_path(__FILE__))
$: << APP_PATH
Dir["#{APP_PATH}/**/lib"].each { |p| $: << p }

module Databasion

  class DatabasionError < StandardError; end
  
  @@config = nil
  
  def self.databate(system, config=nil)
    raise DatabasionError, 'Databasion requires a YAML config file path.' if config.nil?
    @@config = YAML.load(File.open(config))
    
    case system
    when "google"
      googlize
    when "excel"
      excelize
    when "migrate"
      migrate
    end
  end
  
  def self.googlize
    Databasion::Googlize.config = @@config
    Databasion::Googlize.googlebate
  end

  def self.excelize
    Databasion::Excelize.excelbate
  end
  
  def self.migrate
    require 'active_record'
    require 'migration_helpers/init'
    
    logger = Logger.new $stderr
    logger.level = Logger::INFO
    ActiveRecord::Base.logger = logger
    
    files = Dir["%s/*.yml" % @@config['output']['yaml_path']]
    Databasion::Migitize.migrabate(files, @@config)

    Dir[@@config['output']['migrations']['path'] + "/*.rb"].each do |file|
      require file
      set_migrate_connection
      ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
      ActiveRecord::Migrator.migrate(@@config['output']['migrations']['path'], ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
    end
  end
  
  autoload :Googlize, APP_PATH + '/databasion/googlize.rb'
  autoload :Yamalize, APP_PATH + '/databasion/yamalize.rb'
  autoload :Excelize, APP_PATH + '/databasion/excelize.rb'
  autoload :Csvilize, APP_PATH + '/databasion/csvilize.rb'
  autoload :Migitize, APP_PATH + '/databasion/migitize.rb'
  
end