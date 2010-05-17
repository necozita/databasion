require "google_spreadsheet"

module Databasion
  
  class GooglizeError < StandardError; end
  
  class Googlize

    @@master_sheet = 'Database'
    
    def self.config?
      raise 'Googlize cannot load without a config.  Databasion::Googlize.config = /path/to/config.yml' unless defined?(@@config)
      true
    end
    
    def self.config=(data)
      @@config = data
    end
    
    def self.config
      config?
      @@config
    end
    
    def self.session
      @@session
    end
    
    def self.master_sheet=(master)
      @@master_sheet = master
    end
    
    def self.master_sheet
      @@master_sheet
    end
    
    def self.login
      begin
        @@session = GoogleSpreadsheet.login(@@config['login']['username'], @@config['login']['password'])
      rescue
        raise GooglizeError, "Couldn't log into Google."
      end
    end
    
    def self.googlebate
      config?
      login
      process
    end
    
    private
    def self.process
      @@config['sheets'].each do |token|
        spreadsheet = @@session.spreadsheet_by_key(token['key'])
        master_list = get_master(spreadsheet)
        spreadsheet.worksheets.each do |worksheet|
          next unless master_list.include?(worksheet.title)
          data_hash = parse(worksheet)
          Databasion::Yamalize.yamlbate(data_hash, @@config['output']['yaml_path'])
        end
      end
    end
    
    def self.get_master(spreadsheet)
      master_list = Array.new
      spreadsheet.worksheets.each do |worksheet|
        if worksheet.title == @@master_sheet
          worksheet.rows.each do |row|
            master_list.push row.to_s
          end
          break
        end
      end
      raise GooglizeError, "There was no master sheet defined in the spreadsheet %s." % token['name'] if master_list.size == 0
      master_list
    end
    
    def self.parse(worksheet)
      fields  = Array.new
      types   = Array.new
      data    = Array.new

      ignore_cols = Array.new
      
      worksheet.rows.each_with_index do |row, index|
        next if (row.reject { |s| s.strip.empty? }).size == 0

        case row[0]
        when "field"
          row.each do |field|
            fields.push field unless field.empty?
          end
        when "type"
          row.each do |type|
            types.push type unless type.empty?
          end
        when "ignore"
          row.each_with_index do |ignore, i|
            ignore_cols.push i unless ignore.empty?
          end
        when "comment", !row[0].empty?
          nil # ignore
        else
          data.push row[1..row.size] unless (row.reject { |s| s.strip.empty? }).size == 0
        end
      end

      {
        'name'        => worksheet.title,
        'fields'      => fields[1..fields.size],
        'types'       => types[1..types.size],
        'data'        => data,
        'ignore_cols' => ignore_cols
      }
    end
    
  end
  
end