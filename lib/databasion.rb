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
      datacize
    when "update"
      loadalize
    when "svn"
      svnilize
    end
  end
  
  private
  def self.googlize
    Databasion::Googlize.config = @@config
    Databasion::Googlize.googlebate
  end

  def self.excelize
    Databasion::Excelize.excelbate
  end
  
  def self.datacize
    Databasion::Datacize.config = @@config
    Databasion::Datacize.datacize
  end
  
  def self.loadalize
    Databasion::Loadlize.config = @@config
    Databasion::Loadlize.loadalize
  end
  
  def self.svnilize
    Databasion::Svnilize.config = @@config
    Databasion::Svnilize.commit
  end

  def self.set_ar_logger
    ActiveRecord::Base.logger = Databasion::LOGGER
  end
  
  autoload :Applcize, APP_PATH + '/databasion/applcize.rb'
  autoload :Googlize, APP_PATH + '/databasion/googlize.rb'
  autoload :Yamalize, APP_PATH + '/databasion/yamalize.rb'
  autoload :Excelize, APP_PATH + '/databasion/excelize.rb'
  autoload :Csvilize, APP_PATH + '/databasion/csvilize.rb'
  autoload :Migitize, APP_PATH + '/databasion/migitize.rb'
  autoload :Loadlize, APP_PATH + '/databasion/loadlize.rb'
  autoload :Datacize, APP_PATH + '/databasion/datacize.rb'
  autoload :Svnilize, APP_PATH + '/databasion/svnilize.rb'
  
end