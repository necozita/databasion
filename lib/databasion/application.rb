require 'trollop'
require 'fileutils'

module Databasion
  
  class Application
    
    def self.run
      opts = Trollop::options do
        banner <<-EOS
      Databasion - A Google Spreadsheet/Excel -> YAML -> Ruby Migration Database Tool

      Usage:
          databasion [options]
      where [options] are:
        EOS
        opt :create, "Create a base deploy directory", :type => String
        opt :config, "Path to YAML config.  Looks for config/google.yml by default", :type => String
        opt :google, "Load data from Google Spreadsheets"
        opt :file, "Load data from Local Spreadsheets"
        opt :migrate, "Migrate after GoogleLoading"
        opt :load, "Load parsed YAML data into migrated database"
        opt :diff, "Manually check the diff of each database update from the load command"
        opt :svn, "Auto commit the project files (assuming it has been committed to SVN)"
        opt :git, "Auto commit the project files (assuming a working git repo)"
        opt :cron, "Run the version control system via crontab and update on version changes"
        opt :env, "Define the environment with which to run.  Default: development", :type => String
      end
      if opts[:config].nil? and opts[:create].nil?
        config = "config/google.yml"
        puts Dir.pwd
        if File.exist?(Dir.pwd + "/" + config)
          opts[:config] = config
        else  
          Trollop::die :config, "A YAML config must be specified"
        end
      end
      
      if !opts[:env]
        opts[:env] = 'development'
      end

      if opts[:create]
        create_project(opts)
      else
        execute_databasion(opts)
      end
    end
    
    def self.execute_databasion(opts)
      if opts[:cron]
        Databasion.run('cron', opts)
      end
      if opts[:google]
        Databasion.run('google', opts)
      end
      if opts[:file]
        Databasion.run('file', opts)
      end
      if opts[:migrate]
        Databasion.run('migrate', opts)
      end
      if opts[:load]
        Databasion.run('load', opts)
      end
      if opts[:svn]
        Databasion.run('svn', opts)
      end
      if opts[:git]
        Databasion.run('git', opts)
      end
    end
    
    def self.create_project(opts)
      dir = Dir.pwd
      if File.exist?(dir + "/" + opts[:create])
        Databasion::LOGGER.info "A directory with the name %s already exists" % opts[:create]
      else
        Databasion::LOGGER.info "Creating new project directory..."
        create_base(dir, opts[:create])
        create_config(dir, opts[:create])
        copy_config(dir, opts[:create])
        Databasion::LOGGER.info "Done."
      end
    end
    
    def self.create_base(dir, name)
      path = dir + "/" + name
      FileUtils.mkdir path
      Databasion::LOGGER.info "created: %s" % path
    end
    
    def self.create_config(dir, name)
      path = dir + "/" + "%s/config" % name
      FileUtils.mkdir path
      Databasion::LOGGER.info "created: %s" % path
    end
    
    def self.copy_config(dir, name)
      base = File.dirname(File.expand_path(__FILE__)) + "/../../" + "config/example.google.yml"
      path = dir + "/" + "%s/config/google.yml" % name
      FileUtils.cp base, path
      Databasion::LOGGER.info "copied: %s" % path
    end
    
  end
  
end
