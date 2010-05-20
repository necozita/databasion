module Databasion
  
  class Loadlize
    
    @@config = nil
    
    def self.config=(config)
      @@config = config
    end
    
    def self.config
      @@config
    end
   
    def self.loadalize
      Databasion.set_ar_logger
      Databasion::LOGGER.info "Updating from YAML..."

      models = Dir[@@config['output']['migrations']['models'] + "/*.rb"].each { |file| load file }

      models.each do |model|
        f = model.split('/')
        plural_name = f[f.size-1].split(".")[0].pluralize
        camel_name  = f[f.size-1].split(".")[0].camelize

        Databasion::LOGGER.info "Loading %s into database..." % camel_name

        yaml_file = YAML.load_file('%s/%s.yml' % [@@config['output']['yaml_path'], plural_name])

        for row in yaml_file['data']
          klass = eval("%s.new" % camel_name)
          model = camel_name.constantize.find(:first, :conditions => ['id = ?', row['id']])
          if model
            camel_name.constantize.update(model.id, row)
          else
            klass.id = row['id']
            klass.update_attributes(row)
          end
        end
      end
    end
    
  end
  
end