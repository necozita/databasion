module Databasion
  
  class CronSystemError < StandardError; end

  class CronSystem
    
    @@config = nil
    
    def self.config?
      raise CronSystemError, 'CronSystem cannot load without a config.' unless defined?(@@config)
      raise CronSystemError, 'CronSystem now requires an environments config section.' unless defined?(@@config['environments'])
      true
    end
    
    def self.config=(data)
      @@config = data
    end
    
    def self.config
      config?
      @@config
    end
    
    def self.run(opts)
      Databasion::GoogleLoader.config = @@config
      version = Databasion::GoogleLoader.run_version(opts)
      
      version_file = "%s/version_%s" % [@@config['project_base'], opts[:env]]
      
      if File.exist?(version_file)
        old_version = File.open(version_file).readline.strip
        if version > old_version
          Databasion::LOGGER.info "Version changed, running databasion."
          system "cd %s && %s %s" % [@@config['project_base'], File.dirname(__FILE__) + '/../../bin/databasion', @@config['environments'][opts[:env]]['cron_options']]
          write_version(version)
        elsif version < old_version
          Databasion::LOGGER.info "Version rollback is currently not implemented."
        else
          Databasion::LOGGER.info "Version has not changed."
        end
      else
        Databasion::LOGGER.info "CronSystem running for the first time."
        system "cd %s && %s %s" % [@@config['project_base'], File.dirname(__FILE__) + '/../../bin/databasion', @@config['environments'][opts[:env]]['cron_options']]
        write_version(version, version_file)
      end
    end
    
    def self.write_version(version, version_file)
      File.open(version_file, 'w') do |file|
        file.write version
      end
    end
    
  end
  
end
