require "google_spreadsheet"

module Databasion
  
  class GoogleLoaderError < StandardError; end
  
  class GoogleLoader

    @@master_sheet = 'Database'
    
    @@table_def  = 'table'
    @@field_def  = 'field'
    @@type_def   = 'type'
    @@index_def  = 'index'
    @@ignore_def = 'ignore'
    
    def self.config?
      raise GoogleLoaderError, 'GoogleLoader cannot load without a config.' unless defined?(@@config)
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
        raise GoogleLoaderError, "Couldn't log into Google."
      end
    end
    
    def self.run
      config?
      login
      process.each do |data_hash|
        Databasion::YamlBuilder.run(data_hash, @@config['output']['yaml_path'])
      end
    end
    
    private
    def self.process
      Databasion::LOGGER.info "Googlizing..."
      data_list = []
      @@config['sheets'].each do |token|
        spreadsheet = @@session.spreadsheet_by_key(token['key'])
        master_list  = get_master(spreadsheet)
        spreadsheet.worksheets.each do |worksheet|
          next unless master_list.collect { |row| row['spreadsheet'] }.include?(worksheet.title)
          data_hash = parse(worksheet)
          data_hash['connection'] = master_list.collect { |row| row if row['spreadsheet'] == worksheet.title }.reject { |d| d.nil? }[0]
          data_list << data_hash
        end
      end
      Databasion::LOGGER.info "Googlized!"
      data_list
    end
    
    def self.get_master(spreadsheet)
      master_list = []
      header_info = nil
      spreadsheet.worksheets.each do |worksheet|
        if worksheet.title == @@master_sheet
          worksheet.rows.each_with_index do |row, index|
            if index == 0
              header_info = row
              next
            end
            r = {}
            header_info.each_with_index do |h, i|
              r[h.strip] = row[i]
            end
            master_list.push r
          end
          break
        end
      end
      raise GooglizeError, "There was no master sheet defined in the spreadsheet %s." % token['name'] if master_list.size == 0
      master_list
    end
    
    def self.parse(worksheet)
      name    = ''
      plural  = true
      fields  = []
      types   = []
      indexes = []
      data    = []

      ignore_cols = []
      
      worksheet.rows.each_with_index do |row, index|
        next if (row.reject { |s| s.strip.empty? }).size == 0

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
        when @@field_def
          row.each do |field|
            fields.push field unless field.empty?
          end
        when @@type_def
          row.each do |type|
            types.push type unless type.empty?
          end
        when @@index_def
          row.each_with_index do |index, i|
            indexes.push i-1 unless index.empty? or i == 0
          end
        when @@ignore_def
          row.each_with_index do |ignore, i|
            ignore_cols.push i-1 unless ignore.empty? or i == 0
          end
        else
          if row[0].empty?
            data.push row[1..row.size] unless (row.reject { |s| s.strip.empty? }).size == 0
          end
        end
      end

      {
        'name'        => name,
        'plural'      => plural,
        'fields'      => fields[1..fields.size],
        'types'       => types[1..types.size],
        'indexes'     => indexes,
        'data'        => data,
        'ignore_cols' => ignore_cols
      }
    end
    
  end
  
end