module Databasion
  
  class Migrate
    
    @@config = nil
    
    def self.config=(config)
      @@config = config
    end
    
    def self.run(opts)
      require 'migration_helpers/init'

      files = Dir["%s/%s/*.yml" % [opts[:env], @@config['output']['yaml_path']]]
      Databasion::BuildMigration.run(files, @@config, opts)

      Databasion.set_ar_logger
      Databasion::LOGGER.info "Migrating..."

      YAML.load_file('config/database.%s.yml' % opts[:env]).each do |config|
        ActiveRecord::Base.establish_connection(config[1])
        path = opts[:env] + "/" + @@config['output']['migrations']['path'] + "/" + config[0]
        ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
        ActiveRecord::Migrator.migrate(path, ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
      end
    end
    
  end
  
end