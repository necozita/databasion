require 'rubygems'
require 'logger'
require 'active_record'

APP_PATH = File.dirname(File.expand_path(__FILE__))
$: << APP_PATH
Dir["#{APP_PATH}/**/lib"].each { |p| $: << p }

module Databasion
  
  LOGGER = Logger.new $stderr

  class DatabasionError < StandardError; end
  
  @@config = nil
  
  def self.databate(system, config=nil)
    LOGGER.level = Logger::INFO
    
    raise DatabasionError, 'Databasion requires a YAML config file path.' if config.nil?
    @@config = YAML.load(File.open(config))
    
    case system
    when "google"
      googlize
    when "excel"
      excelize
    when "migrate"
      migrate
    when "update"
      load_yaml
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
    require 'migration_helpers/init'
    
    files = Dir["%s/*.yml" % @@config['output']['yaml_path']]
    Databasion::Migitize.migrabate(files, @@config)
    
    Databasion::LOGGER.info "Migrating..."
    
    set_ar_logger

    YAML.load_file('config/database.yml').each do |config|
      ActiveRecord::Base.establish_connection(config[1])
      path = @@config['output']['migrations']['path'] + "/" + config[0]
      ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
      ActiveRecord::Migrator.migrate(path, ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
    end
  end
  
  def self.load_yaml
    Databasion::LOGGER.info "Updating from YAML..."
    
    set_ar_logger
    
    models = Dir[@@config['output']['migrations']['models'] + "/*.rb"].each { |file| load file }
    
    models.each do |model|
      f = model.split('/')
      plural_name = f[f.size-1].split(".")[0].pluralize
      camel_name  = f[f.size-1].split(".")[0].camelize
      
      Databasion::LOGGER.info "Loading %s into database..." % camel_name

      yaml_file = YAML.load_file('%s/%s.yml' % [@@config['output']['yaml_path'], plural_name])
      
      for row in yaml_file['data']
        klass = eval("%s.new" % camel_name)
        model = camel_name.constantize.find(:first, :conditions => ['id = ?', row['id']])
        if model
          camel_name.constantize.update(model.id, row)
        else
          klass.id = row['id']
          klass.update_attributes(row)
        end
      end
    end
  end
  
  private
  def self.set_ar_logger
    ActiveRecord::Base.logger = Databasion::LOGGER
  end
  
  autoload :Applcize, APP_PATH + '/databasion/applcize.rb'
  autoload :Googlize, APP_PATH + '/databasion/googlize.rb'
  autoload :Yamalize, APP_PATH + '/databasion/yamalize.rb'
  autoload :Excelize, APP_PATH + '/databasion/excelize.rb'
  autoload :Csvilize, APP_PATH + '/databasion/csvilize.rb'
  autoload :Migitize, APP_PATH + '/databasion/migitize.rb'
  
end