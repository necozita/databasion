module Databasion
  
  class Migrate
    
    @@config = nil
    
    def self.config=(config)
      @@config = config
    end
    
    def self.run
      require 'migration_helpers/init'

      files = Dir["%s/*.yml" % @@config['output']['yaml_path']]
      Databasion::BuildMigration.run(files, @@config)

      Databasion.set_ar_logger
      Databasion::LOGGER.info "Migrating..."

      YAML.load_file('config/database.yml').each do |config|
        ActiveRecord::Base.establish_connection(config[1])
        path = @@config['output']['migrations']['path'] + "/" + config[0]
        ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
        ActiveRecord::Migrator.migrate(path, ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
      end
    end
    
  end
  
end