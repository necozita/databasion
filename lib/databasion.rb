require 'rubygems'

APP_PATH = File.dirname(File.expand_path(__FILE__))

module Databasion

  class DatabasionError < StandardError; end
  
  def self.help
    puts "Usage:"
    puts " databasion <system> <config path>\n\n"
    puts "Systems:"
    puts " - google : loads data out of Google Spreadsheets"
    puts " - excel  : loads data out of an Excel Spreadsheet"
    puts "\n"
    Kernel.exit(0)
  end

  def self.databate(system, config=nil)
    help if system.nil? and config.nil?
    
    case system
    when "google"
      raise DatabasionError, 'Googlize requires a YAML config file path.' if config.nil?
      googlize(config)
    when "excel"
      raise DatabasionError, 'Excelize requires a YAML config file path.' if config.nil?
      excelize
    end
  end
  
  def self.googlize(config)
    Databasion::Googlize.config = YAML.load(File.open(config))
    Databasion::Googlize.googlebate
  end

  def self.excelize
    Databasion::Excelize.excelbate
  end
  
  autoload :Googlize, APP_PATH + '/databasion/googlize.rb'
  autoload :Yamalize, APP_PATH + '/databasion/yamalize.rb'
  autoload :Excelize, APP_PATH + '/databasion/excelize.rb'
  autoload :Csvilize, APP_PATH + '/databasion/csvilize.rb'
  autoload :Migitize, APP_PATH + '/databasion/migitize.rb'
  
end