module Databasion
  
  class YamalizeError < StandardError; end
  
  class Yamalize
    
    def self.yamlbate(data_hash, output_path=nil)
      raise YamalizeError, 'Databasion::Yamalize requires an output path.' if output_path.nil?
      @@output_path = output_path
      
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
      yaml_output += "  connection:\n"
      data_hash['connection'].each do |key, value|
        yaml_output += "    %s: %s\n" % [key, value] unless ['spreadsheet', 'options'].include?(key)
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
      check_output_path
      f = File.new("%s/%s.yml" % [@@output_path, file_name], 'w')
      f.write(yaml_output)
      f.close
    end
    
    def self.check_output_path
      unless File.exist?(@@output_path)
        FileUtils.mkdir_p(@@output_path)
      end
    end
    
  end
  
end