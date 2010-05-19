require 'trollop'

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
        opt :system, "google, excel, migrate", :type => String
        opt :migrate, "Migrate after Googlizing or Excelizing"
      end
      if opts[:config].nil? and opts[:create].nil?
        config = "/config/google.yml"
        if File.exist?(Dir.pwd + config)
          opts[:create] = config
        else  
          Trollop::die :config, "A YAML config must be specified"
        end
      end
      Trollop::die :system, "System requires a parameter" if opts[:system].nil? and opts[:create].nil?

      if opts[:create]
        create_project(opts)
      else
        execute_databasion(opts)
      end
    end
    
    def self.execute_databasion(opts)
      if opts[:system] and opts[:config]
        Databasion.databate(opts[:system], opts[:config])
        if opts[:migrate] and opts[:system] != 'migrate'
          Databasion.databate('migrate', opts[:config])
        end
      end
    end
    
    def self.create_project(opts)
      dir = Dir.pwd
      if File.exist?(dir + "/" + opts[:create])
        $stdout.puts "A directory with the name %s already exists" % opts[:create]
      else
        $stdout.puts "Creating new project directory..."
        create_base(dir, opts[:create])
        create_config(dir, opts[:create])
        copy_config(dir, opts[:create])
        $stdout.puts "Done."
      end
    end
    
    def self.create_base(dir, name)
      path = dir + "/" + name
      FileUtils.mkdir path
      $stdout.puts "created: %s" % path
    end
    
    def self.create_config(dir, name)
      path = dir + "/" + "%s/config" % name
      FileUtils.mkdir path
      $stdout.puts "created: %s" % path
    end
    
    def self.copy_config(dir, name)
      base = File.dirname(File.expand_path(__FILE__)) + "/../../" + "config/example.google.yml"
      path = dir + "/" + "%s/config/google.yml" % name
      FileUtils.cp base, path
      $stdout.puts "copied: %s" % path
    end
    
  end
  
end