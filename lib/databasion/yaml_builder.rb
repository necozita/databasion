require 'fileutils'

module Databasion
  
  class YamlBuilderError < StandardError; end
  
  class YamlBuilder
    
    def self.run(data_hash, config=nil, opts=nil)
      raise YamalizeError, 'Databasion::YamlBuilder requires an output path.' if config['output']['yaml_path'].nil?
      @@config = config
      @@environment = opts[:env]
      
      Databasion::LOGGER.info "Yamlbating %s..." % data_hash['name']

      yaml_output = process(data_hash)
      write(data_hash['name'], yaml_output)
    end
    
    private
    def self.process(data_hash)
      yaml_output = database_meta(data_hash)
      yaml_output += database_rows(data_hash)
    end
    
    def self.database_meta(data_hash)
      yaml_output = "meta: \n  name: %s\n  plural: %s\n  fields: \n" % [data_hash['name'], data_hash['plural']]
      data_hash['fields'].each_with_index do |field, index|
        next if data_hash['ignore_cols'].include?(index)
        type_data = data_hash['types'][index].split(',')
        yaml_output += "    - field: %s\n      type: %s\n" % [field, type_data[0]]
        yaml_output += "      size: %s\n" % type_data[1] if type_data[1]
        yaml_output += "      default: %s\n" % type_data[2] if type_data[2]
      end
      yaml_output += "  auto: %s\n" % data_hash['auto']
      yaml_output += "  indexes:\n"
      data_hash['indexes'].each do |key, indexes|
        index_list = []
        indexes.each do |index|
          index_list.push data_hash['fields'][index] unless data_hash['ignore_cols'].include?(index)
        end
        yaml_output += "    - index: [%s]\n" % index_list.join(", ")
      end
      yaml_output += "  primaries: [%s]\n" % data_hash['primaries'].join(", ") unless data_hash['primaries'].empty?
      yaml_output += "  connection:\n"
      data_hash['connection'].each do |key, value|
        yaml_output += "    %s: %s\n" % [key, value] unless ['spreadsheet'].include?(key)
      end
      yaml_output += "\n"
    end
    
    def self.database_rows(data_hash)
      yaml_output = "data: \n"
      data_hash['data'].each do |row|
        yaml_row = String.new
        row.each_with_index do |col, index|
          next if data_hash['ignore_cols'].include?(index)
          if yaml_row.size == 0
            yaml_row += "  - %s: %s\n" % [data_hash['fields'][index], col]
          else
            yaml_row += "    %s: %s\n" % [data_hash['fields'][index], col]
          end
        end
        yaml_output += "%s\n" % yaml_row
      end
      yaml_output += "\n"
    end
    
    def self.write(file_name, yaml_output)
      path = @@environment + "/" + @@config['output']['yaml_path']
      check_output_path(path)
      f = File.new("%s/%s.yml" % [path, file_name], 'w')
      f.write(yaml_output)
      f.close
    end
    
    def self.check_output_path(path)
      unless File.exist?(path)
        FileUtils.mkdir_p(path)
      end
    end
    
  end
  
end