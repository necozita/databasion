require "spreadsheet"

module Databasion
  
  class SpreadsheetLoaderError < StandardError; end
  
  class SpreadsheetLoader
    
    @@session = nil

    @@environment_sheet = 'Environments'
    
    @@table_def   = 'table'
    @@primary_def = 'primary'
    @@auto_def    = 'auto'
    @@field_def   = 'field'
    @@type_def    = 'type'
    @@index_def   = 'index'
    @@ignore_def  = 'ignore'
    
    def self.config?
      raise SpreadsheetLoaderError, 'SpreadsheetLoader cannot load without a config.' unless defined?(@@config)
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
    
    def self.environment_sheet=(environment)
      @@environment_sheet = environment
    end
    
    def self.environment_sheet
      @@environment_sheet
    end
    
    def self.login
      begin
        @@session = GoogleSpreadsheet.login(@@config['login']['username'], @@config['login']['password'])
      rescue
        raise GoogleLoaderError, "Couldn't log into Google."
      end
    end
    
    def self.run(opts=nil)
      @@environment = opts[:env]
      config?
#     login
      process.each do |data_hash|
        Databasion::YamlBuilder.run(data_hash, @@config, opts)
      end
    end
    
    def self.run_version(opts=nil)
      config?
      login if session.nil?
      fetch_environment_version(opts)
    end
    
    private
    def self.process
      Databasion::LOGGER.info "Loading local Spreadsheet..."
      data_list = []
      @@config['sheets'].each do |token|
        spreadsheet = Spreadsheet.open(token['name'], 'rb')
        db_list = get_env(spreadsheet)
        table_list = get_table(spreadsheet)


#        spreadsheet = @@session.spreadsheet_by_key(token['key'])
#        master_list  = get_master(spreadsheet)
        spreadsheet.worksheets.each do |worksheet|
          next unless table_list.collect { |row| row['spreadsheet'] }.include?(worksheet.name)
          data_hash = parse(worksheet)
          data_hash['connection'] = table_list.collect { |row| row if row['spreadsheet'] == worksheet.name }.reject { |d| d.nil? }[0]
          data_list << data_hash
        end
      end
      Databasion::LOGGER.info "Googlized!"
      data_list
    end
    
    def self.get_table(spreadsheet)
      table_list = []
      header_info = nil
      spreadsheet.worksheets.each do |worksheet|
        if worksheet.name == "_tables"
          worksheet.each_with_index do |row, index|
            if index == 0
              header_info = row
              next
            end
            r = {}
            header_info.each_with_index do |h, i|
              r[h.strip] = row[i]
            end
            table_list.push r
          end
          break
        end
      end
      raise SpreadsheetLoaderError, "There was no master sheet defined in the spreadsheet _tables." if table_list.size == 0
      table_list
    end
    
    def self.get_env(spreadsheet)
      Databasion::LOGGER.info '_'+@@environment
      db_list = []
      header_info = nil
      spreadsheet.worksheets.each do |worksheet|
        if worksheet.name == "_"+@@environment
          worksheet.each_with_index do |row, index|
            if index == 0
              header_info = row
              next
            end
            r = {}
            header_info.each_with_index do |h, i|
              r[h.strip] = row[i]
            end
            db_list.push r
          end
          break
        end
      end
      raise SpreadsheetLoaderError, "There was no db sheet defined in the spreadsheet %s." % ('_'+@@environment) if db_list.size == 0
      db_list
    end
    
    def self.parse(worksheet)
      name      = ''
      plural    = true
      auto      = false
      fields    = []
      primaries = []
      types     = []
      indexes   = {}
      data      = []

      ignore_cols = []
      
      worksheet.each_with_index do |row, index|
        next if (row.reject { |s| s.to_s.strip.blank? }).size == 0

        case row[0]
        when @@table_def
          begin
            d = row[1].split(",")
            name = d[0].strip
            plural = false if d[1].strip == 'false'
          rescue
            name = row[1]
            plural = true
          end
        when @@primary_def
          row.each do |field|
            unless field.blank?
              primaries.push field
            end
          end
        when @@auto_def
          row.each do |field|
            unless field.blank?
              auto = true
            end
          end
        when @@field_def
          row.each do |field|
            fields.push field.to_s unless field.to_s.blank?
          end
        when @@type_def
          row.each do |type|
            types.push type unless type.to_s.blank?
          end
        when @@index_def
          row.each_with_index do |field, i|
            unless field.to_s.blank? or i == 0
              indexes.include?(field) ? (indexes[field].push i-1) : (indexes[field] ||= [i-1])
            end
          end
        when @@ignore_def
          row.each_with_index do |ignore, i|
            ignore_cols.push i-1 unless ignore.blank? or i == 0
          end
        else
          if row[0].to_s.blank?
            data.push row[1..row.size] unless (row.reject { |s| s.to_s.strip.blank? }).size == 0
          end
        end
      end
      
      raise DatabasionError, "You cannot create a table without at least one 'auto' field, and/or one or more 'primary' fields." if primaries.empty? and !auto

      {
        'name'        => name,
        'plural'      => plural,
        'fields'      => fields[1..fields.size],
        'auto'        => auto,
        'primaries'   => primaries,
        'types'       => types[1..types.size],
        'indexes'     => indexes,
        'data'        => data,
        'ignore_cols' => ignore_cols
      }
    end
    
#    def self.fetch_environment_version(opts)
#      version = nil
#      @@config['sheets'].each do |token|
#        spreadsheet = @@session.spreadsheet_by_key(token['key'])
#        spreadsheet.worksheets.each do |worksheet|
#          if worksheet.title == environment_sheet
#            worksheet.rows.each_with_index do |row, index|
#              next if index == 0
#              version = row[1] if row[0] == opts[:env]
#            end
#          end
#        end
#      end
#      raise GoogleLoaderError, "An Environments spreadsheet was not found in any of the Google Spreadsheets supplied in google.yml" if version.nil?
#      version
#    end
#    
  end
  
end
