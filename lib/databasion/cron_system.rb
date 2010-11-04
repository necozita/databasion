module Databasion
  
  class CronSystemError < StandardError; end

  class CronSystem
    
    @@config = nil
    
    def self.config?
      raise CronSystemError, 'CronSystem cannot load without a config.' unless defined?(@@config)
      true
    end
    
    def self.config=(data)
      @@config = data
    end
    
    def self.config
      config?
      @@config
    end
    
    def self.run
      Databasion::GoogleLoader.config = @@config
      version = Databasion::GoogleLoader.run_version
      
      if File.exist?(@@config['cron']['version']['file'])
        old_version = File.open(@@config['cron']['version']['file']).readline.strip
        if version > old_version
          Databasion::LOGGER.info "Version changed, running databasion."
          system "cd %s && databasion %s" % [@@config['cron']['project_base'], @@config['cron']['options']]
          write_version(version)
        elsif version < old_version
          Databasion::LOGGER.info "Version rollback is currently not implemented."
        else
          Databasion::LOGGER.info "Version has not changed."
        end
      else
        Databasion::LOGGER.info "CronSystem running for the first time."
        system "cd %s && databasion %s" % [@@config['cron']['project_base'], @@config['cron']['options']]
        write_version(version)
      end
    end
    
    def self.write_version(version)
      File.open(@@config['cron']['version']['file'], 'w') do |file|
        file.write version
      end
    end
    
  end
  
end
