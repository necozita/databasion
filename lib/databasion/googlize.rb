require "google_spreadsheet"

module Databasion
  
  class GooglizeError < StandardError; end
  
  class Googlize

    @@master_sheet = 'Database'
    
    def self.config?
      raise 'Googlize cannot load without a config.' unless defined?(@@config)
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
      
      Databasion::LOGGER.info "Googlizing..."
      process
      Databasion::LOGGER.info "Googlized!"
    end
    
    private
    def self.process
      @@config['sheets'].each do |token|
        spreadsheet = @@session.spreadsheet_by_key(token['key'])
        master_list  = get_master(spreadsheet)
        spreadsheet.worksheets.each do |worksheet|
          next unless master_list.collect { |row| row['spreadsheet'] }.include?(worksheet.title)
          data_hash = parse(worksheet)
          data_hash['connection'] = master_list.collect { |row| row if row['spreadsheet'] == data_hash['name'] }.reject { |d| d.nil? }[0]
          Databasion::Yamalize.yamlbate(data_hash, @@config['output']['yaml_path'])
        end
      end
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
        when "table"
          if d = row[1].split(",")
            name = d[0]
            plural = false if d[1] == 'false'
          else
            name = row[1]
          end
        when "field"
          row.each do |field|
            fields.push field unless field.empty?
          end
        when "type"
          row.each do |type|
            types.push type unless type.empty?
          end
        when "index"
          row.each_with_index do |index, i|
            indexes.push i-1 unless index.empty? or i == 0
          end
        when "ignore"
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