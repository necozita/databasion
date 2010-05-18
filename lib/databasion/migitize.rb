require 'active_support'

module Databasion
  
  class MigitizeError < StandardError; end
  
  class Migitize
    
    @@migration_start = 100
    
    def self.migrabate(file_list=[], config=nil)
      raise MigitizeError, 'Databasion::Migitize requires an array list of files.  Try Yamalizing first.' if file_list.empty?
      raise MigitizeError, 'Databasion::Migitize requires a parsed YAML config.' if config.nil?
      @@config = config
      parse(file_list)
    end
    
    private
    def self.parse(file_list)
      file_list.each do |file|
        meta = YAML.load(File.open(file))['meta']
        process(meta)
      end
    end
    
    def self.process(meta)
      write_yaml(migration_class(meta), meta['name'])
      write_ruby(ruby_model(meta), meta['name'])
    end
    
    def self.migration_class(meta)
      migration = migration_connection(meta)
      migration += "class %sMigration < ActiveRecord::Migration\n" % meta['name'].camelize
      migration += migration_up(meta)
      migration += migration_down(meta)
      migration += "end\n"
    end
    
    def self.migration_connection(meta)
      model = "def set_migrate_connection\n"
      model += "  ActiveRecord::Base.establish_connection(\n"
      count = 0
      meta['connection'].each do |key, value|
        count += 1
        next if value.nil?
        model += "    :" + key + " => " + '"' + value + '"' unless ['spreadsheet', 'options'].include?(key)
        model += "," unless meta['connection'].size == count
        model += "\n"
      end
      model += "  )\n"
      model += "end\n"
    end
    
    def self.migration_up(meta)
      migration = "  def self.up\n"
      if meta['fields'].collect {|f| f['field']}.include?('id')
        migration += "    create_table :%s, :id => false do |t|\n" % set_table_name(meta)
      else
        migration += "    create_table :%s do |t|\n" % set_table_name(meta)
      end
      migration += migration_up_fields(meta)
      migration += "    end\n"
      migration += "  end\n"
    end
    
    def self.migration_up_fields(meta)
      migration = ''
      meta['fields'].each do |field|
        if field['field'] == 'id'
          migration += '      t.integer :id, :options => "PRIMARY KEY"' + "\n"
        else
          migration += "      t.%s :%s" % [field['type'], field['field']]
          migration += ", :size => %s" % field['size'] if field['size']
          migration += ", :default => %s" % field['default'] if field['default']
          migration += "\n"
        end
      end
      migration
    end
    
    def self.migration_down(meta)
      migration = "  def self.down\n"
      migration += "    drop_table :%s\n" % meta['name'].pluralize
      migration += "  end\n"
    end
    
    def self.set_table_name(meta)
      return meta['name'].pluralize if meta['plural']
      meta['name'].pluralize
    end
    
    def self.ruby_model(meta)
      model = "class %s < ActiveRecord::Base\n" % ruby_model_name(meta)
      model += ruby_model_table_name(meta)
      model += "end\n"
      model += ruby_model_connection(meta)
    end
    
    def self.ruby_model_name(meta)
      meta['plural'] ? meta['name'].camelize.pluralize : meta['name'].camelize
    end
    
    def self.ruby_model_table_name(meta)
      return "set_table_name %s\n" % meta['name'] unless meta['plural']
      ''
    end
    
    def self.ruby_model_connection(meta)
      model = "%s.establish_connection(\n" % ruby_model_name(meta)
      count = 0
      meta['connection'].each do |key, value|
        count += 1
        next if value.nil?
        model += "  :" + key + " => " + '"' + value + '"' unless ['spreadsheet', 'options'].include?(key)
        model += "," unless meta['connection'].size == count
        model += "\n"
      end
      model += ")\n"
    end
    
    def self.write_yaml(migration, file_name)
      check_output_path(@@config['output']['migrations']['path'])
      f = File.new("%s/%s_%s_migration.rb" % [@@config['output']['migrations']['path'], @@migration_start, file_name], 'w')
      f.write(migration)
      f.close
      @@migration_start += 1
    end
    
    def self.write_ruby(model, file_name)
      check_output_path(@@config['output']['migrations']['models'])
      f = File.new("%s/%s.rb" % [@@config['output']['migrations']['models'], file_name], 'w')
      f.write(model)
      f.close
    end

    def self.check_output_path(path)
      unless File.exist?(path)
        FileUtils.mkdir_p(path)
      end
    end
    
  end
  
end