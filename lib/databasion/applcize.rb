require 'trollop'
require 'fileutils'

module Databasion
  
  class Applcize
    
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
        opt :google, "Googlize data from Google Spreadsheets"
        opt :migrate, "Migrate after Googlizing or Excelizing"
        opt :update, "Load parsed YAML into migrated database"
        opt :svn, "Auto commit the project files (assuming it has been committed to SVN)"
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

      if opts[:create]
        create_project(opts)
      else
        execute_databasion(opts)
      end
    end
    
    def self.execute_databasion(opts)
      if opts[:google]
        Databasion.databate('google', opts[:config])
      end
      if opts[:migrate]
        Databasion.databate('migrate', opts[:config])
      end
      if opts[:update]
        Databasion.databate('update', opts[:config])
      end
      if opts[:svn]
        Databasion.databate('svn', opts[:config])
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