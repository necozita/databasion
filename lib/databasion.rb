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
  
  def self.run(system, config=nil, opts=nil)
    LOGGER.level = Logger::INFO
    
    raise DatabasionError, 'Databasion requires a YAML config file path.' if config.nil?
    @@config = YAML.load(File.open(config))
    
    case system
    when "google"
      run_google
    when "migrate"
      run_migrate
    when "load"
      run_load(opts)
    when "svn"
      run_svn
    when "git"
      run_git
    when "cron"
      run_cron
    end
  end
  
  private
  def self.run_google
    Databasion::GoogleLoader.config = @@config
    Databasion::GoogleLoader.run
  end
  
  def self.run_migrate
    Databasion::Migrate.config = @@config
    Databasion::Migrate.run
  end
  
  def self.run_load(opts)
    Databasion::LoadData.config = @@config
    Databasion::LoadData.run(opts)
  end
  
  def self.run_svn
    Databasion::SvnCommitter.config = @@config
    Databasion::SvnCommitter.commit
  end
  
  def self.run_git
    Databasion::GitCommitter.config = @@config
    Databasion::GitCommitter.commit
  end
  
  def self.run_cron
    Databasion::CronSystem.config = @@config
    Databasion::CronSystem.run
  end

  def self.set_ar_logger
    ActiveRecord::Base.logger = Databasion::LOGGER
  end
  
  autoload :Application,    APP_PATH + '/databasion/application.rb'
  autoload :GoogleLoader,   APP_PATH + '/databasion/google_loader.rb'
  autoload :YamlBuilder,    APP_PATH + '/databasion/yaml_builder.rb'
  autoload :Migrate,        APP_PATH + '/databasion/migrate.rb'
  autoload :BuildMigration, APP_PATH + '/databasion/build_migration.rb'
  autoload :LoadData,       APP_PATH + '/databasion/load_data.rb'
  autoload :SvnCommitter,   APP_PATH + '/databasion/svn_committer.rb'
  autoload :GitCommitter,   APP_PATH + '/databasion/git_committer.rb'
  autoload :CronSystem,     APP_PATH + '/databasion/cron_system.rb'
  
end