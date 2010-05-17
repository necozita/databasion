require 'active_support'

module Databasion
  
  class MigitizeError < StandardError; end
  
  class Migitize
    
    @@migration_start = 100
    
    def self.migrabate(file_list=[], config=nil)
      raise MigitizeError, 'Databasion::Migitize requires an array list of files.' if file_list.empty?
      raise MigitizeError, 'Databasion::Migitize requires a parsed YAML config.' if config.nil?
      @@config = config
      parse(file_list)
    end
    
    private
    def self.parse(file_list)
      file_list.each do |file|
        meta = YAML.load(File.open(file))['meta']
        migration = process(meta)
        write(migration, meta['name'])
      end
    end
    
    def self.process(meta)
      migration = "class %s < ActiveRecord::Migration\n" % meta['name'].camelize.pluralize
      migration += "  def self.up\n"
      if meta['fields'].collect {|f| f['field']}.include?('id')
        migration += "    create_table :%s, :id => false do |t|\n" % meta['name'].pluralize
      else
        migration += "    create_table :%s do |t|\n" % meta['name'].pluralize
      end
      meta['fields'].each do |field|
        if field['field'] == 'id'
          migration += '      t.integer, :id, :options => "PRIMARY KEY"' + "\n"
        else
          migration += "      t.%s, :%s" % [field['type'], field['field']]
          migration += ", :size => %s" % field['size'] if field['size']
          migration += ", :default => %s" % field['default'] if field['default']
          migration += "\n"
        end
      end
      migration += "    end\n"
      migration += "  end\n"
      migration += "  def self.down\n"
      migration += "    drop_table :%s\n" % meta['name'].pluralize
      migration += "  end\n"
      migration += "end\n"
    end
    
    def self.write(migration, file_name)
      check_output_path
      f = File.new("%s/%s_%s.rb" % [@@config['output']['migration_path'], @@migration_start, file_name], 'w')
      f.write(migration)
      f.close
      @@migration_start += 1
    end

    def self.check_output_path
      unless File.exist?(@@config['output']['migration_path'])
        FileUtils.mkdir_p(@@config['output']['migration_path'])
      end
    end
    
  end
  
end