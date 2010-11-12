require 'active_support'
require 'erb'
require 'fileutils'

module Databasion
  
  class BuildMigrationError < StandardError; end
  
  class BuildMigration
    
    @@migration_start = 100
    
    def self.run(file_list=[], config=nil, opts=nil)
      raise BuildMigrationError, 'Databasion::BuildMigration requires an array list of files.  Try GoogleLoading first.' if file_list.empty?
      raise BuildMigrationError, 'Databasion::BuildMigration requires a parsed YAML config.' if config.nil?
      @@config = config
      @@environment = opts[:env]
      parse(file_list)
    end
    
    private
    def self.configure_start(dbname)
      @@migration_start = 100
      files = Dir[@@environment + "/" + @@config['output']['migrations']['path'] + "/%s/*.rb" % dbname].collect { |file| file.split("/").pop }.sort
      @@migration_start = files[files.size-1].split("_")[0].to_i + 1 if files.size > 0
    end
    
    def self.parse(file_list)
      Databasion::LOGGER.info "Migrabating..."
      database_configs = []
      file_list.each do |file|
        meta = YAML.load(File.open(file))['meta']
        database_configs.push meta['connection']
        process(meta)
      end
      write_database_yaml(database_configs)
      Databasion::LOGGER.info "Migrabated!"
    end
    
    def self.process(meta)
      configure_start(meta['connection']['dbname'])
      write_migration(migration_class(meta), meta['name'], meta['connection']['dbname'])
      write_ruby(ruby_model(meta), meta['name'])
      Databasion::LOGGER.info "Migrabated %s..." % meta['name']
    end
    
    def self.migration_class(meta)
      template = ''
      File.open(File.expand_path(File.dirname(__FILE__)) + '/templates/migration.erb', 'r') { |f| template = f.read }
      class_name  = meta['name'].camelize
      table_name  = meta['name']
      indexes     = meta['indexes']
      fields      = meta['fields']
      primaries   = meta['primaries']

      migration = ERB.new(template, nil, ">")
      migration.result(binding)
    end
    
    def self.set_table_name(meta)
      return meta['name'].pluralize if meta['plural']
      meta['name']
    end
    
    def self.ruby_model(meta)
      template = ''
      File.open(File.expand_path(File.dirname(__FILE__)) + '/templates/model.erb', 'r') { |f| template = f.read }
      class_name = ruby_model_name(meta)
      table_name = ruby_model_table_name(meta)
      fields = meta['connection'].clone
      fields.delete('spreadsheet')
      fields.delete('options')
      fields.delete('dbname')

      model = ERB.new(template, nil, ">")
      model.result(binding)
    end
    
    def self.ruby_model_name(meta)
      meta['name'].camelize
    end
    
    def self.ruby_model_table_name(meta)
      return meta['name'] unless meta['plural']
      nil
    end
    
    def self.write_migration(migration, file_name, sub_path)
      path = @@environment + "/" + @@config['output']['migrations']['path'] + "/" + sub_path
      check_output_path(path)
      unless migration_exists?(file_name)
        f = File.new("%s/%s_%s_migration.rb" % [path, @@migration_start, file_name], 'w')
        f.write(migration)
        f.close
        @@migration_start += 1
      else
        f = File.open(find_migration_file(file_name), 'w')
        f.write(migration)
        f.close
      end
    end
    
    def self.write_ruby(model, file_name)
      path = @@environment + "/" + @@config['output']['migrations']['models']
      check_output_path(path)
      f = File.new("%s/%s.rb" % [path, file_name], 'w')
      f.write(model)
      f.close
    end
    
    def self.write_database_yaml(database_configs)
      output = {}
      database_configs.uniq.compact.collect do |config|
        dbname = config['dbname']
        config.delete('dbname')
        output[dbname] = config
      end
      f = File.open("config/database.%s.yml" % @@environment, 'w')
      f.write(YAML.dump(output))
      f.close
      Databasion::LOGGER.info "Wrote database config..."
    end
    
    def self.migration_exists?(file_name)
      find_migration_file(file_name) ? true : false
    end
    
    def self.find_migration_file(file_name)
      files = Dir[@@environment + "/" + @@config['output']['migrations']['path'] + "/**/*.rb"]
      files.each do |file|
        chunks = file.split("/").pop.split(".")[0].split("_")
        return file if chunks[1..chunks.size-2].join("_") == file_name
      end
      false
    end

    def self.check_output_path(path)
      unless File.exist?(path)
        FileUtils.mkdir_p(path)
      end
    end
    
  end
  
end