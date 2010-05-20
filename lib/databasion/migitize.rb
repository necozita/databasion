require 'active_support'
require 'erb'
require 'fileutils'

module Databasion
  
  class MigitizeError < StandardError; end
  
  class Migitize
    
    @@migration_start = 100
    
    def self.migrabate(file_list=[], config=nil)
      raise MigitizeError, 'Databasion::Migitize requires an array list of files.  Try Yamalizing first.' if file_list.empty?
      raise MigitizeError, 'Databasion::Migitize requires a parsed YAML config.' if config.nil?
      @@config = config
      
      Databasion::LOGGER.info "Migrabating..."
      configure_start
      parse(file_list)
      Databasion::LOGGER.info "Migrabated!"
    end
    
    private
    def self.configure_start
      files = Dir[@@config['output']['migrations']['path'] + "/**/*.rb"].collect { |file| file.split("/").pop }.sort
      @@migration_start = files[files.size-1].split("_")[0].to_i if files.size > 0
    end
    
    def self.parse(file_list)
      database_configs = []
      file_list.each do |file|
        meta = YAML.load(File.open(file))['meta']
        database_configs.push meta['connection']
        process(meta)
      end
      write_database_yaml(database_configs)
    end
    
    def self.process(meta)
      write_migration(migration_class(meta), meta['name'], meta['connection']['dbname'])
      write_ruby(ruby_model(meta), meta['name'])
      Databasion::LOGGER.info "Migrabated %s..." % meta['name']
    end
    
    def self.migration_class(meta)
      template = ''
      File.open(File.expand_path(File.dirname(__FILE__)) + '/templates/migration.erb', 'r') { |f| template = f.read }
      class_name = meta['name'].camelize
      table_name = meta['name']
      fields = meta['fields']

      migration = ERB.new(template, nil, ">")
      migration.result(binding)
    end
    
    def self.set_table_name(meta)
      return meta['name'].pluralize if meta['plural']
      meta['name'].pluralize
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
      meta['plural'] ? meta['name'].camelize.pluralize : meta['name'].camelize
    end
    
    def self.ruby_model_table_name(meta)
      return meta['name'] unless meta['plural']
      nil
    end
    
    def self.write_migration(migration, file_name, sub_path)
      puts sub_path
      path = @@config['output']['migrations']['path'] + "/" + sub_path
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
      check_output_path(@@config['output']['migrations']['models'])
      f = File.new("%s/%s.rb" % [@@config['output']['migrations']['models'], file_name], 'w')
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
      f = File.open("config/database.yml", 'w')
      f.write(YAML.dump(output))
      f.close
    end
    
    def self.migration_exists?(file_name)
      return true if find_migration_file(file_name)
      false
    end
    
    def self.find_migration_file(file_name)
      files = Dir[@@config['output']['migrations']['path'] + "/**/*.rb"]
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