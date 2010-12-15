module Databasion
  
  class LoadData
    
    @@config = nil
    
    def self.config=(config)
      @@config = config
    end
    
    def self.config
      @@config
    end
   
    def self.run(opts)
      Databasion.set_ar_logger
      Databasion::LOGGER.info "Updating from YAML..."

      models = Dir[opts[:env] + "/" + @@config['output']['migrations']['models'] + "/*.rb"].each { |file| load file }

      models.each do |model|
        f = model.split('/')
        normal_name = f[f.size-1].split(".")[0]
        plural_name = normal_name.pluralize
        camel_name  = normal_name.camelize

        Databasion::LOGGER.info "Loading %s into database..." % camel_name

        begin
          yaml_file = YAML.load_file('%s/%s.yml' % [opts[:env] + "/" + @@config['output']['yaml_path'], plural_name])
        rescue
          yaml_file = YAML.load_file('%s/%s.yml' % [opts[:env] + "/" + @@config['output']['yaml_path'], normal_name])
        end

        if yaml_file['data']
          camel_name.constantize.delete_all
          yaml_file['data'].each do |row|
            klass = eval("%s.new" % camel_name)
            row.each do |key, value|
              eval("klass.%s = '%s'" % [key, value])
            end
            klass.save
          end
        end
      end
    end
    
  end
  
end